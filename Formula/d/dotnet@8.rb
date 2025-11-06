class DotnetAT8 < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/dotnet/archive/refs/tags/v8.0.121.tar.gz"
  sha256 "a1f127c69ddd4b665bd300b0458e7359adf2d9f720e101de327e87e504a938ca"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(8(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "8a3ad77e8f5afebb904199bb91e4d60371bc655eba32dff50bf684bd6858d3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "433442b742af45ca942c9f93269aefd93955f2dd47b935374d025d56a725f429"
  end

  keg_only :versioned_formula

  # https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core#lifecycle
  deprecate! date: "2026-11-10", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "grep" => :build # grep: invalid option -- P
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  on_intel do
    # Building on Intel Sonoma or later results in stack overflow on restore.
    # See https://github.com/Homebrew/homebrew-core/issues/197546
    depends_on maximum_macos: [:ventura, :build]
  end

  resource "release.json" do
    url "https://github.com/dotnet/dotnet/releases/download/v8.0.121/release.json"
    sha256 "ba61d54adf402098d6772763dbc021bf60a82c28abeebefba94c74b50e1dbbc4"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "Update release.json resource!" if resource("release.json").version != version
    buildpath.install resource("release.json")

    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", Formula["grep"].libexec/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_path

      # Deparallelize to reduce chances of missing PDBs
      ENV.deparallelize
      # Avoid failing on missing PDBs as unable to build bottle on all runners in current state
      # Issue ref: https://github.com/dotnet/source-build/issues/4150
      inreplace "build.proj", /\bFailOnMissingPDBs="true"/, 'FailOnMissingPDBs="false"'

      # Disable crossgen2 optimization in ASP.NET Core to work around build failure trying to find tool.
      # Microsoft.AspNetCore.App.Runtime.csproj(445,5): error : Could not find crossgen2 tools/crossgen2
      inreplace "src/aspnetcore/src/Framework/App.Runtime/src/Microsoft.AspNetCore.App.Runtime.csproj",
                "<CrossgenOutput Condition=\" '$(TargetArchitecture)' == 's390x'",
                "<CrossgenOutput Condition=\" '$(TargetOsName)' == 'osx'"
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib

      # Use our libunwind rather than the bundled one.
      inreplace "src/runtime/eng/SourceBuild.props",
                "--outputrid $(TargetRid)",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Work around build script getting stuck when running shutdown command on Linux
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
      system "./build.sh", "--clean-while-building", "--online", "--release-manifest", "release.json"
    end

    libexec.mkpath
    tarball = buildpath.glob("artifacts/*/Release/dotnet-sdk-*.tar.gz").first
    system "tar", "--extract", "--file", tarball, "--directory", libexec
    doc.install libexec.glob("*.txt")
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "src/sdk/scripts/register-completions.bash" => "dotnet"
    zsh_completion.install "src/sdk/scripts/register-completions.zsh" => "_dotnet"
    man1.install Utils::Gzip.compress(*buildpath.glob("src/sdk/documentation/manpages/sdk/*.1"))
    man7.install Utils::Gzip.compress(*buildpath.glob("src/sdk/documentation/manpages/sdk/*.7"))
  end

  def caveats
    <<~TEXT
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    TEXT
  end

  test do
    target_framework = "net#{version.major_minor}"

    (testpath/"test.cs").write <<~CSHARP
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
    CSHARP

    (testpath/"test.csproj").write <<~XML
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
    XML

    system bin/"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
    assert_equal "#{testpath}/test.dll,a,b,c\n", output

    # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
    # See https://github.com/Homebrew/homebrew-core/issues/197546
    resource "sbom-tool" do
      url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v3.0.1.tar.gz"
      sha256 "90085ab1f134f83d43767e46d6952be42a62dbb0f5368e293437620a96458867"
    end
    resource("sbom-tool").stage do
      system bin/"dotnet", "restore", "src/Microsoft.Sbom.Tool", "--disable-build-servers", "--no-cache"
    end
  end
end
