class DotnetAT8 < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/dotnet/archive/refs/tags/v8.0.132.tar.gz"
  sha256 "e488a0713415c47ca93b6c8a185cabfa4fa58facb83e0f7c306e3bf5e86ab021"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(8(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "460827928cc5dc3dcf6947b5fdcf929278d48428883aa625f65b2f27d804ac7b"
    sha256 cellar: :any, arm64_tahoe:       "5119edbd3ff185892d140b4bb61665187fcf3f7e40cdd3cf34bf0311d61cbce1"
    sha256 cellar: :any, arm64_sequoia:     "35de497a5719c674565776e360c87b1b9e5ccfd755fd535e6a615c25e5aa6890"
    sha256 cellar: :any, arm64_linux:       "78aa22779b2c03961bf653adf6b23e9ea79e6847af84848074eea87b0f8893e1"
    sha256 cellar: :any, x86_64_linux:      "e602b24799924b77ebae0c8e48040ea9dba40509f25285429e87ec10f418c52b"
  end

  keg_only :versioned_formula

  # https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core#lifecycle
  deprecate! date: "2026-11-10", because: :unsupported
  disable! date: "2027-11-10", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"

  on_macos do
    depends_on "grep" => :build # grep: invalid option -- P
    depends_on "llvm@20" => :build if DevelopmentTools.clang_build_version >= 2100
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
    depends_on "zlib-ng-compat"

    on_intel do
      depends_on "llvm" => :build

      fails_with :gcc do
        cause "Fatal error. Internal CLR error"
      end
    end
  end

  resource "release.json" do
    url "https://github.com/dotnet/dotnet/releases/download/v8.0.132/release.json"
    sha256 "8c94ced5e6788003f762cd59f0e635ac935cf298374b449d89ba10bb93280380"

    livecheck do
      formula :parent
    end
  end

  # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
  # See https://github.com/Homebrew/homebrew-core/issues/197546
  resource "docfx", :test do
    url "https://github.com/dotnet/docfx/archive/refs/tags/v2.78.4.tar.gz"
    sha256 "255f71f4a6fc7b9ffd0c598d0eba11630dc01262f1fa45ec4f1794508f7033cf"
  end

  def install
    odie "Update release.json resource!" if resource("release.json").version != version
    buildpath.install resource("release.json")

    # .NET built with Apple Clang 2100 (based on LLVM 21) sporadically crashes
    if DevelopmentTools.clang_build_version >= 2100
      ENV["CC"] = formula_opt_bin("llvm@20")/"clang"
      ENV["CXX"] = formula_opt_bin("llvm@20")/"clang++"
      ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"
    end

    # Make sure CoreCLR builds with our compiler shims
    ENV["CLR_CC"] = which(ENV.cc)
    ENV["CLR_CXX"] = which(ENV.cxx)

    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", formula_opt_libexec("grep")/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

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
    end

    # Skip shutting down build servers, which gets stuck on Linux and fails in the macOS build sandbox
    # Ref: https://github.com/dotnet/source-build/discussions/3105#discussioncomment-4373142
    inreplace "build.sh", '"$CLI_ROOT/dotnet" build-server shutdown', ""
    inreplace "repo-projects/Directory.Build.targets",
              '<Exec Command="$(DotnetToolCommand) build-server shutdown" />',
              ""

    system "./prep.sh"
    if OS.mac?
      # MSBuild hardcodes `/tmp` for its sockets, which the build sandbox denies, so prefer a short `TMPDIR`.
      # Below 38 characters, even its longest socket name (66) fits macOS's 103-byte socket path limit.
      # https://github.com/Homebrew/brew/issues/23934
      inreplace "src/msbuild/src/Shared/NamedPipeUtil.cs",
                'Path.Combine("/tmp", pipeName)',
                'Path.Combine(Path.GetTempPath().Length < 38 ? Path.GetTempPath() : "/tmp", pipeName)'
      # Avoid worker nodes, which the unpatched bootstrap MSBuild cannot reach
      system ".dotnet/dotnet", "build", "src/msbuild/src/MSBuild/MSBuild.csproj", "--configuration", "Release",
             "-maxcpucount:1"
      # Replace the bootstrap SDK's MSBuild with the patched one
      cp Dir["src/msbuild/artifacts/bin/MSBuild/Release/net*/{MSBuild,Microsoft.Build*}.dll"],
         Dir[".dotnet/sdk/*"].first
      # `build.sh` builds MSBuild again into the same directory
      rm_r "src/msbuild/artifacts"
    end
    # The sandbox also denies the Roslyn compiler server's `/tmp` socket, so compile without it
    ENV["UseSharedCompilation"] = "false" if OS.mac?
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
    # Runtime 8.0.32 puts user mutexes under the passwd home, which the Linux test sandbox blocks
    ENV["XDG_RUNTIME_DIR"] = testpath

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

    resource("docfx").stage do
      msbuild_args = ["-p:TargetFrameworks=net8.0"]
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache", *msbuild_args
    end
  end
end
