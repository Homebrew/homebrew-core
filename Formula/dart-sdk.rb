class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.19.4.tar.gz"
  sha256 "3b41fc5c897f67a6a6b8080150b0ec15e7002096fdd3a735c139a4d25af5ed32"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89dd6a2765aaa70ad15566fb501a27a944950d7f1cafd5cb13eff1aeb3b11f90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6233df09dfda634511870c1e23eacf81e018e8abefda6d7ba902fa53c14e881"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d83d0a60ba9fe72ad0330cc77fb4a1da1b53854219f73fe7271b10926d0e8ac"
    sha256 cellar: :any_skip_relocation, ventura:        "263cfd3b0f6d18422df449b314454d75211336d3355fc5e7494dcb301a9e00e3"
    sha256 cellar: :any_skip_relocation, monterey:       "b69de926b8f46e00b0ccba4dfa08b522d5278bae35b8bb18b47a4ff835886a91"
    sha256 cellar: :any_skip_relocation, big_sur:        "929813add55c7f5f2ca5a842e5374230a1946a0b8a910bb656bcefcd2032284a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5594d7e9a4d2131a3edc70e4c9b22c19ceee430198de0b357e11c55573372c80"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "d4c6cbeb61f3be41476de5ce984ec528d8209e88"
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
