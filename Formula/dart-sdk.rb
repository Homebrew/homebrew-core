class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.19.4.tar.gz"
  sha256 "0abe4874bf327bc2e95e8584628f40f0c324b1cbb96935c02d65c2d5d8d13d0a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f4ea044819c4b64ef80c64d9ec66589483b5fceec99d1708a2f16b3dce0cdf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "105db5e2e8cdce1e367e78c93c1fd2e51770b4322416f389e6573d6990380ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e70ff667e3c51102cbc1af76d15c407ae2c5fc0a10b978b8fef77d95201ff70c"
    sha256 cellar: :any_skip_relocation, ventura:        "2d45ce90ca3c41cb41d1f00c743569c32ef83bbd5d1464597230a84b2111bbb9"
    sha256 cellar: :any_skip_relocation, monterey:       "330647d2be9c8720237f4bcb33018f2bc622f8ffd49e7bb297064e3bf2eb50a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "46c78764732e9d5691a99e768b95ee99e0b580b370880f8e2d374623dfec3450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f67029e1021f1482a7aa43c017a34ca63b6ed225185ca5c96f74cc27b3df7b5f"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "d8fb7c966777733491e11037dcdb2bce1c16662d"
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
