class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.3.1.tar.gz"
  sha256 "07ee48063e212c4d1e5c7b6db762df7297428b497048ef60884c1e277e49273c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4751fcd4dae930ffd00c682e0d5674f4c23ff3c79db0a1ade910f5177c098c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab696c663b8dd568bf068ede59bd03249862f06daa784ac8527d4d329ca10d5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5cce7042970a001e463fccc787ae6a083137f3ede71f6bb21770b2ff52223a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8d5b674a15178c23ff5363fc8f6aa19bbd9bc6e713188aac258135875c19cdb"
    sha256 cellar: :any_skip_relocation, ventura:        "2425df40bf53f55693c4c32c5ba27ba1ceabb9cce3ceef46af13528a6f0db59a"
    sha256 cellar: :any_skip_relocation, monterey:       "58bb99391908e53602fdc95a641ea1f44cee349306b6d2eb18a9640c443414ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea2c592ca58779ae4065de7355263aef9e9d04cb07d6f098f0c682c2a1e028f"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "1382a3f980bd079c6529f8bc2ca6a2acaf300789"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

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
