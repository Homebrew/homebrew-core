class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.11.4/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43c342c42220efb0e8f2f77ea1aebbfaa9db2a8aef692eb98bd6280b7885420d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de265c3c99ac612f79f26a5556527f0ffb7ec32df63a99440fc0e74f27f5b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650f0ae31f16d10e9b691d5c9a44d05837c79d7b724737d811d789c8a5035a94"
    sha256 cellar: :any_skip_relocation, sonoma:        "48d7fe226d8879076400eb199f9c6db7c071f4ed7168893b0e66c5bdb0b65e0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a7908bae85fea2c0b12ff4629c24114638363a1bf2f9adfb89adfb0a7c913a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26fb9b632354bf75343bf07bddba74caf23dc2ea27411fd6eeb4d63fd55d0e3e"
  end

  depends_on "ninja" => :build
  depends_on xcode: :build # for xcodebuild
  depends_on "dart-sdk" => :test

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "4ce8ba39a3488397a2d1494f167020f21de502f3"
    version "4ce8ba39a3488397a2d1494f167020f21de502f3"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")
    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", buildpath/"depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    # FIXME: Workaround for https://github.com/dart-lang/sdk/issues/63089
    if OS.mac? && MacOS::Xcode.version >= "26.4"
      inreplace "sdk/build/config/compiler/BUILD.gn",
                "\"-Wno-tautological-constant-compare\",",
                "\"-Wno-tautological-constant-compare\", \"-Wno-deprecated-declarations\","
    end

    cd "sdk" do
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      out = OS.mac? ? "xcodebuild" : "out"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "copy_dart_aotruntime"
      bin.install "#{out}/Release#{arch.upcase}/dart-sdk/bin/dartaotruntime"
      prefix.install_metafiles Pathname.pwd
    end
  end

  test do
    dart = Formula["dart-sdk"].bin/"dart"
    system dart, "create", "dart-test"
    cd "dart-test" do
      system dart, "compile", "aot-snapshot", "bin/dart_test.dart"
      assert_match "Hello world: 42!", shell_output("#{bin}/dartaotruntime bin/dart_test.aot")
    end
  end
end
