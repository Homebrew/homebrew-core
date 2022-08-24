class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.17.7.tar.gz"
  sha256 "d9618ec11555b3e72b7c2a1ecd1eb4750f24fe126a8a5cd636924385153dbaa7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5b315f5af51beeaba91a824647d3e26b73f338556ef92f5381bd695ea6791c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2cf8d6fb625253fca61f9daa4925f0df9a8fa45feb255162967d301db143d3a"
    sha256 cellar: :any_skip_relocation, monterey:       "e063b42b35a331eb9750fcfcc57ac109dff3288f9f57f7fba0d946671f5fbcf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1eb3a46e31b37d0c905f2f6c1199629fa7fd43415d99a12bb290186c3843d9f"
    sha256 cellar: :any_skip_relocation, catalina:       "5f1e63328a70b1871a93fc56151b9c21e09d29eb486b653234002c13cf094512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "972fcdb5706e39a92ca10b9c460156206b636263df574e9fdd9459834fc57b0a"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "138bff2823590b3f3db440425bf712392defb7de"
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
