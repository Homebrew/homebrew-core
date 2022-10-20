class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.2.tar.gz"
  sha256 "67636c0a231f91de91d35368fb8d731e149ef99c7784ffcafc6088d8cbd6d892"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91ad6aa6f0949bcbdc7f39414d83a7a7366c25571b0142acb2f9b7dc84a307d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe29676cfc1dda59333237f72d68890a345ce2c6b4458ac20b987b754ff681f3"
    sha256 cellar: :any_skip_relocation, monterey:       "b9e94434961fd355e2a96d171967530f7a969bf1844a46a0492a46d338fa237d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1023efda59920866cf433ea556a354fb4cbab551c3079ce87cb445899630ed73"
    sha256 cellar: :any_skip_relocation, catalina:       "03fbcfd445cb97d9b465c610554a737d6b870353391954bce72a7b3b8e5e362d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eff2c3797618c35a2aa0b89900d6993cd3da97e3eb93369dba4b7dd9224689c"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "e3ed6a8e015bada7f2708d990b5e8c4d01bcf047"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV.append_path "PATH", "#{buildpath}/depot-tools"
    system "fetch", "--no-history", "dart"
    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--no-goma", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.capitalize}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output(bin/"dart run")
    end
  end
end
