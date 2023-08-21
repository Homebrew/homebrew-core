class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.1.0.tar.gz"
  sha256 "ab104a71e4f50bf152c8afce738ad12ea6ed882d5b9ed17122ff9763b2c98cff"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3599284ef1a799432d22967e0ba7c5c05fb6d2495593e6c6128c96918567413"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af0ef6ed5416ef9f7272b04351314a98424b9b274dbcaabe603d6273d80a577a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c04ca9e4bceb6a2edb486cd39a031c9b53b810672510fc064120272cf7229adb"
    sha256 cellar: :any_skip_relocation, ventura:        "2b621029c154cccf2133e01d150679f4d8ce53ffa33ef804f8c4f2f115732f75"
    sha256 cellar: :any_skip_relocation, monterey:       "db16615c6e7ceeed76580cb70c90bf670bf46e47e35e931b4a9ea154e76e3a4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b95cad55ed44625a4c99b7be106c4a33eee18f1b81354593c8f311fa7643972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357dfe8cbe3c95cf544e0a0c51f4cdae8c0b0cbbd80e9eb4e7b942039d1a13be"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "1c4052d88ac510a3db4351e52c088cac524c726c"
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
