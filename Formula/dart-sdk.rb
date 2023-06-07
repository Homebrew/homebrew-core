class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.0.4.tar.gz"
  sha256 "62bc5b8477e4e64aac734256cef3feaaf88c8782a296989ff81e2f04ddbe143b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f308e3fafca34430f21a4fcc85454cab19b85fb35af3b3c4a64f6caf8a1af68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "656a208b7dd1185017a857dd5443b64d2c97a0caab03184a6ae1b0296fae00b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "858266966c972f6726a816f1b4f40e7b2d401af9c10037fd70dde413eeb03d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "59e30f6c620d9dff42ac23ecbf8def7af115682f7ab8a95f8588bc0ab062dae6"
    sha256 cellar: :any_skip_relocation, monterey:       "afa3c51e359349ef1e75d3f3adfaf5f3aa67f22c2479ad773ba0e8034cc161ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d66b41d0507283c45fc1e35d3c3c9bf12faf7438ce5c6721a520aa54cf463b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f190f89d868ff482a2429fec69184e66882f2112ff940456f027ee63f7ecd4d4"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "19ea2048e4fdee2118f5abccf3a6b6eafdd04c8f"
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
