class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.13.1.tar.gz"
  sha256 "107ab0b58674d35a46553e1848d11cf34ac45f37b8a488c1733dd220492eb921"
  license "BSD-3-Clause"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "09bfc63e0a576f60dec3437521b9968cf1bc3f581cd1a47245609c039f33e745"
    sha256 cellar: :any, arm64_sequoia: "98ec76af7ccfc555dffb74bb4709de226288e3f42eb073b85fe446258e8fd805"
    sha256 cellar: :any, arm64_sonoma:  "ea99ad93714a051676ceab9202d0b34d6dfe18c7feb697b74dd48173572fd4a8"
    sha256 cellar: :any, sonoma:        "d1d3d4c95531ffaa47f9d8b7ee81f5e7f096aa421264256a2f259bb34e5cf541"
    sha256 cellar: :any, arm64_linux:   "23c2bd344f2f34fb33bad409ef095d4c1611aed9af2b376eb0b9de499917e977"
    sha256 cellar: :any, x86_64_linux:  "d50b17a88e7b94717536ca7e4d4dad39365abb6ea4553399fef857014ab2708b"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "8ff4a322a17ea014561931720c8153904cd0a9c3"
    version "8ff4a322a17ea014561931720c8153904cd0a9c3"

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
