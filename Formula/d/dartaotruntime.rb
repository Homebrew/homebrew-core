class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.13.3/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84cd16acf230ae245e9e8ceeba1db15964a8f0cdd65b4ab76ad23eb3f0d1d461"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "874eebf42fd268371e55411baa47b420e57e6722e8ad98a7f598db8ae5f78a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57265a76550b5a1dd6e8cc5003410d4d533eb0a01aa71812f06fd4ec1663da4d"
    sha256 cellar: :any,                 arm64_linux:       "9b0ca40301c174d20635d33f3a7e319cc38a24ffbbc749602afe3ce435f1a5c1"
    sha256 cellar: :any,                 x86_64_linux:      "371cc589cc8fbd3689cfef83bb4971d1d1547f35a8d4d4ece255ab4f91aa2681"
  end

  depends_on "ninja" => :build
  depends_on "dart-sdk" => :test

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  on_macos do
    depends_on xcode: :build # for xcodebuild
  end

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "cb70c994a656601dc6a0d423f49ff57503bd70bc"
    version "cb70c994a656601dc6a0d423f49ff57503bd70bc"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")
    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", buildpath/"depot-tools"

    # Roll clang to include lld support for arm64e.x1 targets in the macOS 27 SDK (llvm/llvm-project#222721)
    # TODO: Remove when upstream rolls clang past that commit, see https://github.com/dart-lang/sdk/issues/64264
    system "gclient", "config", "--name", "sdk",
           "--custom-var", 'clang_version="git_revision:07d67299a15ce03b053736e2d31a668ee0576987"',
           "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    cd "sdk" do
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      out = OS.mac? ? "xcodebuild" : "out"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "copy_dart_aotruntime"
      bin.install "#{out}/Release#{arch.upcase}/dart-sdk/bin/dartaotruntime"
      prefix.install_metafiles Pathname.pwd
    end
  end

  test do
    dart = formula_opt_bin("dart-sdk")/"dart"
    system dart, "create", "dart-test"
    cd "dart-test" do
      system dart, "compile", "aot-snapshot", "bin/dart_test.dart"
      assert_match "Hello world: 42!", shell_output("#{bin}/dartaotruntime bin/dart_test.aot")
    end
  end
end
