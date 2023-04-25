class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.19.6.tar.gz"
  sha256 "44a20076dd0e237d59af97bd075f31820bd26a18a6a9c260324f495d67fac165"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18ac957619fe81347ae7a84c9580fcf96d04683bd6f0281e2cdbd98269b33084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc46dbeda4a89721d76d5f5f0ddc2726f0fbb9c6df9013eaeda0ebbed20150c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ebe5b9c6cb765a3bc65592c201dceb0cb054bccc93ad3d0598490b03208b3fa"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a81ba000bae86d2092f20ef8893bfbbfec400b6104443a3718fa69a261b808"
    sha256 cellar: :any_skip_relocation, monterey:       "14dd0e0f79e49a601d11035f144b160fb7d11f3a9ea78ec2f16bae80865db24d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fd8196f20def64630a834fe388a15a01c323628908aa36e3245252a41c3165e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34527126a2c5000bd46b645ce30f2ae02d239dce08a0949bd9f2f10476d6ca09"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "cf4658579326856b9b25cfe2efbfc8683af88814"
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
