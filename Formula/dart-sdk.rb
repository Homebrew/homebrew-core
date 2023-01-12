class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.7.tar.gz"
  sha256 "5debf3c723e08c4f52e4780fec166b1838589f3395f3e3a60b12e09586f58063"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4b55a176446049b4f00374be67581ad71f8b19ad84c40051884d2025e685820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da6d847ca9d2e5810fb21110fa29fc42a3ed745a7ccd002439ea0668be999b8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae40577e6be6708c2358f5f1a4f3cd475508fdb6e31816ee9fec38e842fd2b12"
    sha256 cellar: :any_skip_relocation, ventura:        "3801df2fea7fb40db33ce77a3f08c4799ef29fe5da3b7d769a75b1cd5001f925"
    sha256 cellar: :any_skip_relocation, monterey:       "9122dddcb87aa0a38ae2ebbbd68ae72e597f77ae085422d135b7363f0cbeea6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6f680b9b87053b8aa781ef554a97107c3e4dbd08fa67bfe55cff9467bab7288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ea94a8113d3e4893776db8648fea800b0d022ae16ef08e86a21fc2d945e706"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "6fde0fbe9226ae3fc9f5c709adb93249924e5c49"
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
