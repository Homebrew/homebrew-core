class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.17.6.tar.gz"
  sha256 "24849c94ed5af1f90033f3412c98486b049e13198cefdf69d2884022057c3da2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fcb8b99ee781914dc156e8e01706389b3fee09a39ec2e88d3e24cee9e135539"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5db38078dfab47af2a103cfcb2eade38804d7fc4207bea5f015e8c8567cbeb1c"
    sha256 cellar: :any_skip_relocation, monterey:       "81d1e692115100b20dc864a3e826ad1b30ba4613b2ce5054d2670eb0dcdf0148"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b635b97ad8b742b7a9a6a18ec01bc715eafc2901c5f8e34782cf4c98e66bd03"
    sha256 cellar: :any_skip_relocation, catalina:       "570326aac3f51eafc502fd0fc7cab40c703cc7ed7ac5a89442f8f8622adb3776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a58aea583e1fa4af188b15f04b9785eb0b86ca99c4d33826f2988b91457255f"
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
