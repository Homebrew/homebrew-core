class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.1.3.tar.gz"
  sha256 "672fb8f8093261792e3d9a521f7c12780269b46595955a66f1865c5ecc7f37db"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "742927543df0de0cf53b52f9d64265d178bdd836d43ea70f7fd255a67a6db7ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "533b63b9596304831f0d37cc8e59e11f1c27b9694edc42d8b4c94fa3e82339d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6057eaaa9439f0e8b33703e6845755fe7a206ddbeeb2c358adff1d5f95ec45a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf8f126aa89ecf5c4667f974d38e586623558f09bd8403fc4f98335c1bff12bb"
    sha256 cellar: :any_skip_relocation, ventura:        "72e62bb5ef726aa1bcf07ce6d9f543a4511401b0c8f60ea667a4b8b247078630"
    sha256 cellar: :any_skip_relocation, monterey:       "0241f14097fbbb533f530effb43bd9e85449a9db5e2cda0a2ebf63a24e0ca009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1170d154c3c5cabb5de33b47efeeeb39e645f42115684dedaf12b8a5e1401e31"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "34e0ecf20e6876a036a79966d6e8997420e76dbb"
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
