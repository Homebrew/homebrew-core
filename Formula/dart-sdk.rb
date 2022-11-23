class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.5.tar.gz"
  sha256 "81bbc28a148fe147676a8dde1dae4579cd7e760be60c332c2dfd3dcfbade0a93"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19f30f600506f0998da1cc1c6f02e4a11892a8e5c2d703322a4d1a077e8bfed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1afe7c32068fbe6a49b39b77d8c2b3b84c93dd891fb81c7cc0ba648416e67779"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85266bdd96cac98fd17fc8277bf954527ef0181bb33ab2c14904bb03e3cd8798"
    sha256 cellar: :any_skip_relocation, monterey:       "fb8a5f78fd5aee44c439e88092ea52439af44fcbe3d310a57f6213e813cc6370"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e57d4d622e664ac2555f8274eb470f73f83059d5ceb30bdd9dd74ab055a3513"
    sha256 cellar: :any_skip_relocation, catalina:       "7e72823eb416b7abe4b8e0070323328ba69aa198ffe6b59f2f16c8a428c6665e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa3d88a12d446f978aba5363767a8d4e9858e1d25e19794822eb165544ee232"
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
