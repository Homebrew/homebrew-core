class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/dotnet.git",
      tag:      "v8.0.4",
      revision: "83659133a1aa2b2d94f9c4ecebfa10d960e27706"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b1c4d845fd53cf8e41b84989e28646df229b2ce71f6849cfbb41e8fec58bb1a1"
    sha256 cellar: :any,                 arm64_ventura:  "91db87f569f5a66979951af3fecf40eccfec203e9b5a66995bd21d0161f0efa5"
    sha256 cellar: :any,                 arm64_monterey: "de1524e6d2bbdb0a5806b852bd4b4d7858d135d9bec9a938ca6243ef5b1ef59e"
    sha256 cellar: :any,                 sonoma:         "62612a47e65da5e8d8bbf38e09a747e77da589da8850d79eeac06c5d46ed518e"
    sha256 cellar: :any,                 ventura:        "91582419b6db04b8214688821439a20b3cff72d8e5a9d225f5ca680908a79738"
    sha256 cellar: :any,                 monterey:       "78c01438e9fbaf80015de638229b0fe221b1d6ad3a0f925d1d060a75e6a12704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955c0c5f9e833fa9efb29ae092bce5dd4a84e61aa4f4663ccdaef2affd0664b3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "icu4c"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  # Upstream only directly supports and tests llvm/clang builds.
  # GCC builds have limited support via community.
  fails_with :gcc

  def install
    if OS.mac?
      # Deparallelize to avoid missing PDBs
      ENV.deparallelize

      # Disable crossgen2 optimization in ASP.NET Core to work around build failure trying to find tool.
      # Microsoft.AspNetCore.App.Runtime.csproj(445,5): error : Could not find crossgen2 tools/crossgen2
      # TODO: Try to remove in future .NET 8 release or when macOS is officially supported in .NET 9
      inreplace "src/aspnetcore/src/Framework/App.Runtime/src/Microsoft.AspNetCore.App.Runtime.csproj",
                "<CrossgenOutput Condition=\" '$(TargetArchitecture)' == 's390x'",
                "<CrossgenOutput Condition=\" '$(TargetOsName)' == 'osx'"
    else
      ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib
      ENV.append_to_cflags "-I#{Formula["krb5"].opt_include}"

      # Use our libunwind rather than the bundled one.
      inreplace "src/runtime/eng/SourceBuild.props",
                "--outputrid $(TargetRid)",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Work around build script getting stuck when running shutdown command on Linux
      # TODO: Try removing in the next release
      # Ref: https://github.com/dotnet/source-build/discussions/3105#discussioncomment-4373142
      inreplace "build.sh", '"$CLI_ROOT/dotnet" build-server shutdown', ""
      inreplace "repo-projects/Directory.Build.targets",
                '<Exec Command="$(DotnetToolCommand) build-server shutdown" />',
                ""
    end

    system "./prep.sh"
    # We unset "CI" environment variable to work around aspire build failure
    # error MSB4057: The target "GitInfo" does not exist in the project.
    # Ref: https://github.com/Homebrew/homebrew-core/pull/154584#issuecomment-1815575483
    with_env(CI: nil) do
      system "./build.sh", "--clean-while-building", "--online"
    end

    libexec.mkpath
    tarball = Dir["artifacts/*/Release/dotnet-sdk-*.tar.gz"].first
    system "tar", "-xzf", tarball, "--directory", libexec
    doc.install Dir[libexec/"*.txt"]
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "src/sdk/scripts/register-completions.bash" => "dotnet"
    zsh_completion.install "src/sdk/scripts/register-completions.zsh" => "_dotnet"
    man1.install Dir["src/sdk/documentation/manpages/sdk/*.1"]
    man7.install Dir["src/sdk/documentation/manpages/sdk/*.7"]
  end

  def caveats
    <<~EOS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    EOS
  end

  test do
    target_framework = "net#{version.major_minor}"
    (testpath/"test.cs").write <<~EOS
      using System;

      namespace Homebrew
      {
        public class Dotnet
        {
          public static void Main(string[] args)
          {
            var joined = String.Join(",", args);
            Console.WriteLine(joined);
          }
        }
      }
    EOS
    (testpath/"test.csproj").write <<~EOS
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
      </Project>
    EOS
    system bin/"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath/"test.csproj"
    assert_equal "#{testpath}/test.dll,a,b,c\n",
                 shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
  end
end
