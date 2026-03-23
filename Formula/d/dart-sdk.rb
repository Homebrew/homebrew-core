class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.11.3.tar.gz"
  sha256 "504d63f7ee9e761a260a3ae3750ba0e2783486bd3a724c2435b54fa19d0cc3ed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba80774e397f1d1792c82a841b22b2a2831945679d3c19168dfb8fd8b412d61a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d556e8950bc51d051568d1a2854d8de50aab53a5db12f48ee3efb7d7ec0285a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0d71af1d628dfdf1660946cd203e62479b19dfc90c95927cec06d4924d02b39"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b93c97eaefb8f30b41d06d8d764ac4f29f3840a265760ef1d2197a5c4a6890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1071ef930d0ec99295ea10286e8e765a68934db8d90f64902402a70e1c5dbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3854b33729bb68b928d2d40df0d12ae59108cb65cdfce514159be3e489d82fab"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

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
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.upcase}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output("#{bin}/dart run")
    end
  end
end
