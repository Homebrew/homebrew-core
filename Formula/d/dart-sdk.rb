class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.5.3.tar.gz"
  sha256 "ee2cfea26c9eb22a5e7df5f68e13863d4e55ff14c06a286bf98d866f7b85652d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dbe3f3ce63191e2dad39e7e3fe650f03abdfb5208ff6fd25d475b5d81d0f8957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33df6aff7c934d202ad951712e65297c328bbb7a664b18db0dd358d792f54f8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2290b1e7a595b3ee1a10af0448e2c428862cf5290384bd921c77176be7ce13f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d7e3e3982681c4cef922a09621bcd0ba289924109355c0f7c07853211d77cc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a90b8969725508ccbc36a1dd49aab93b83837a1aa8945b6c7e0c9a66b0264257"
    sha256 cellar: :any_skip_relocation, ventura:        "18d998f96c77c59795809b5e1b113751c9a0562642b7a515985c771df33f22bd"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b41424561f6e5ad49c82561e7b79395146ab0b2627909655026fcf88a0a949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c3bbf11e1091ec4a4b3ed82c32560db5f040eef56c91102492b2c4adb386d63"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "20a0cda9e99abf86d37cb42cd98b1be9b727fdf8"
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
