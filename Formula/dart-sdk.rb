class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.5.tar.gz"
  sha256 "81bbc28a148fe147676a8dde1dae4579cd7e760be60c332c2dfd3dcfbade0a93"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e54eb1ad60e51fc7dcd09db3daaf17fa484c5e93a0aa7fc6e1647b1b8790b3fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab46b71a5d5cd98771718c4f3b899aee10335af23dfb71284c504a2a48ad47e7"
    sha256 cellar: :any_skip_relocation, ventura:        "8d27db1d59a60a8f85b7b9c6d4214fbd754398b8863e07d8dad0b9c874612e1a"
    sha256 cellar: :any_skip_relocation, monterey:       "7083771968ac19e5ff24756e27bed189395a437d5f029731edaec1a32586c6e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c1dac15c963574b664d6d4451f4f503197bc9b4f5d943760da491fec5ee21a5"
    sha256 cellar: :any_skip_relocation, catalina:       "8a5e1ed39d5ce06585a41b6dc2800ec3c20711be217ae3b19fac256260ea9fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f5aa6a7ebbe11317e13b66018048eff98092ae8b6ac456d242e170abac4e3ac"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "6fde0fbe9226ae3fc9f5c709adb93249924e5c49"
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
