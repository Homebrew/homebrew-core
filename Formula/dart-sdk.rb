class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.2.tar.gz"
  sha256 "67636c0a231f91de91d35368fb8d731e149ef99c7784ffcafc6088d8cbd6d892"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1069a073eb75849031ea3f34cc1c2aae6eee611f77956c3968bdcf76f1ba4ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7741b74fd38e31e9a4a8eddd5fa8031cfc92ebcbb610f28e8311e0c484f1dae"
    sha256 cellar: :any_skip_relocation, monterey:       "cad0305fad7a0257827d152598f54379723d4087f91f646517cf6d1623703249"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8fc8a0a55992e2ace955b58ad907ca7c0262fe8c44cff6a2955126b6f4834de"
    sha256 cellar: :any_skip_relocation, catalina:       "811c38632c92d80638112eaaae55906ba6c164cb634826bd074b413f1d14df40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab4920cd2531daaf430f71c1a49aeca4565f7be0db0a548b0aae7d12b576c54"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "e3ed6a8e015bada7f2708d990b5e8c4d01bcf047"
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
