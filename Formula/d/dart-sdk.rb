class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.2.4.tar.gz"
  sha256 "fa1f16545300b4001c9bd46e7efe7ffd840704e231062a71d3d27fbf27fe2a5e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f43b172577066081dc904467ba8038c700e7f6788a21998315451cc29074e37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1950971a490a9eb856021c5baf34c408d9dda957c5b11639d4bd667de0e49ce7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9bc2d1b5246d38d58d87f3ea2120ce50bf95bd6695795f9c12822af3ab9153"
    sha256 cellar: :any_skip_relocation, sonoma:         "f117c92fd0bacc285c98d527b5ecf17f48b1b5519f4013b4291ef10af1b2afa0"
    sha256 cellar: :any_skip_relocation, ventura:        "73aa6b489260558bcbb5bf027957ea337d5e97e864d7ca57411636d5d168cf93"
    sha256 cellar: :any_skip_relocation, monterey:       "b1322fdd314a9ab5cabc01025c244ca1da0d577b9073f945d307219e39c2debc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e985d8a44008b267deafb3ccfc167f172d199aabc62e6d6cd2f98cfc1dcfbe5c"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "007dd45a94b8fe400fb69113f7999fed185cb5c1"
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
