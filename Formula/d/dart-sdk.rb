class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.7.2.tar.gz"
  sha256 "cbbd5a98ce4678b33e52a91378b9ecb7a5899e676fbd686c4a0023c7dd263504"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "941de6fca1c6743b6609a2836b85bdebbc2f4f8682ed3021869390b017e57ce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91314dadbeba5de73f4ceac3dfadd2941f574e4b13100e06105132093aae7bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e81408fd448e14620d78dd9b21a8bbd89ccdb6b9ccad847451cad9da02f0dffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c0cc2adc157ad9ee87f155dbd9eca74a8f5d2848a73a7f0d23419c822ce8f66"
    sha256 cellar: :any_skip_relocation, ventura:       "eb2904adbeba335b81e205e9bbaff97b880f5173847d773f7686f3d7fa8c0a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9893ac760d7db4f244671119e9cdccd18320b14008f098821ff47c61a46cb69d"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "0445e00a089e163c4dcf1659b9fe38edec2d5adc"
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
