class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.8.1.tar.gz"
  sha256 "61e2bbaaca96938af68f18ef6eb4c238cb258d2dc531cb0d3737f5a4eda87e03"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c35d06f8ec90b54c82bf94aff0024bf791f3b0ab1fe8148f20f9d28ddd36112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9f9f1a704bfc7e1756fe54eef63309e52042342cf2adfd5570804fd0e6c5f06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5be8d23742798ca7ea1f114fe9741f8e51e3d7401119bf6c0851dfbb6d27bcef"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51d6e3d84ad417d733d45b263b6849f9d2a0c2816fdd325ba68fe396877e7d1"
    sha256 cellar: :any_skip_relocation, ventura:       "3c76ec6b44cc0a7074788381a51941c5d00638cacb7b85c59954da1e5547bfb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef8d6a55952ef4adea57e7e89268c8db9a2dbe286769c2092b5410c0c7ec9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca0468e41eafe812369c47a6dca36fd087f63edbd18b0d7b706eeff54d9c12a9"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "0b1d80ab9e9f1413234641d193639e5daa92dd5b"
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
      libexec.install Dir["#{out}/Release#{arch.upcase}/dart-sdk/*"]
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
