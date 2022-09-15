class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.1.tar.gz"
  sha256 "8de19d9586b5606f02dd9726f33eea9e4e12ea3c499c5875e82cd7ff38f3ccdc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b9e60caaf8c28aedb28aa2690c896e1c3afceb3ab96bb7f0a245be9ef5a25c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94dc2720c843ff127bbf22851eba7b87d69d957e9d72b01351662105188ba5f8"
    sha256 cellar: :any_skip_relocation, monterey:       "64ff849ca6aca6dd107319d947da9707b5ca67dcb5833506985598c562f7ab52"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7f83d2ca2d4120cb28a604d9a9e0aa24999b39c289298ec98cc7a074a887acb"
    sha256 cellar: :any_skip_relocation, catalina:       "3e4aebda8dd6d537fb43d21e7336eacf480dcf418690abf87d0a8b049560116e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc093c2c18453ef700a9f6dfc70c06f29071cdcc408f4404f42a2b9dcc6b08a"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "5e4d74983ecbfb404909c7243c23cd733db4565d"
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
