class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.4.tar.gz"
  sha256 "6644c8e1ce88953bd3364a29de0dab321b21fb9a7af6a22e965d4f2afbd64d4e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f406a3274bc0328d2015548817fd384d7a88f2839c1b4b671ce7945d4ca77564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ff83e26da7157c2ab9552973f364f8928307ec62fd83ddcb274adb9ceaa2d7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccc280363c2e848ae22cc593714b8b0fbf800a1fb5f460769234369045dd8e74"
    sha256 cellar: :any_skip_relocation, monterey:       "8487d6a52c7c64c9a988c1c159bf453d33adb4a393419be24444c7ae3963b8f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "51bd3c7e027a52d5f77271c0f5a2545ce1b37819261679cf301a06a2f36f2522"
    sha256 cellar: :any_skip_relocation, catalina:       "33463884165a4abd52d0ce543854e15ceaefa56907ae1360b21f2c080f19fb45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352ffd0ffb04691b9fa2e88eabc04df681c7dd0db3d694568195bfa80f6f79e8"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "bd0cea6acd9ed0476b6634b08da740093715a654"
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
