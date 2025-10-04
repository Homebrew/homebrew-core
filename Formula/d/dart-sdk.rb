class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.9.4.tar.gz"
  sha256 "b7413dd8d13e09b0eca5b197a7d2c4dbc0fa0624cf234eb24f9d09aba05ebb99"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0322feac8b63067a9ae15a596ff217cddefb60ce1cf3268203eb595bf8771fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc208243c6193cb4d9fa5c2f9ea72c320f06cd80c19388d73e8f7edaaa2c185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44eb73795c9618c29a903c40a8f993b28c4640db826fd6c662735bbde4ee3fd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a555caadc2aab0f1433bf158a8a7319ccadd228d83d5481ff4a8110009096a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3736f543a2a0a651ad3890d748e2148b191af4cd1a11a7f6681c9fa910e811ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07150c7dc91ab6163dbae3ad74cb67cfda014d687b2bc957ff8fd896a63dfec7"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "49ffe22ecdd00d319d5750ba494e4ba5ac6bb855"
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
