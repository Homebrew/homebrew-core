class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.17.5.tar.gz"
  sha256 "4a9bc470b593b6e138343ec318f4a98912e92cfb9c2e10fc2b84ec508541e7cc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e36d6f7950b4d49aa4a9cde7864802db46ae9619200767ff634523abf9fa8d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73488f140cd830003b66408e8c278df0b3fa9deb11f1425098deca932b9eae59"
    sha256 cellar: :any_skip_relocation, monterey:       "70ee3dc8141822beb8499ef210197450a9151326917ab1860bb2ff057c0bcfae"
    sha256 cellar: :any_skip_relocation, big_sur:        "95b7fa95916a64568fb4f9b77ad9932226692a21ea04ef1daf88b0cf76b0fcdd"
    sha256 cellar: :any_skip_relocation, catalina:       "492ea121f58ee2c244ea6a25d894c5a7f431a011821c690239ffc2da3f6f0f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc910f4ee20e9aa0dd9c266369495b32151e14f8f1878226e9a3b0188bc2ded4"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "138bff2823590b3f3db440425bf712392defb7de"
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
