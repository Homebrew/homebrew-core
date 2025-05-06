class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.7.3.tar.gz"
  sha256 "5f7fd432c95adce1a00060675c5b52c001f8b540bcbe8eb1684a77ba4a02f2bd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ad4a48127c60d434f74365ca59381592a7a4f1536aef3d2d78e6d2d9b6494e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f90cd5b367c173fdff23742a95bca90adc2e3b8c659f0ec793985c728f8de35e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c79a1a97598b2ced9424456b4ac349798e9dc3609c2932891c3da336c84afddf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b093bb6e35f91068b8e4334da32a625650f73309b1362f4fbaf1611cf4937263"
    sha256 cellar: :any_skip_relocation, ventura:       "9d027e74e46f579aa40e1d74c566f5a3a144b6aabeea3e4b7a78a4b0fe5eb3aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f4bcb3418812e9907eae6fb5e0a25aaa9c6189110907e7f512599789191a8bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade94ed4188f4e323662abe3c1251949ff65afae6055af06ac67e62267dbf146"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "463ce5a855f4a65c75791c29a1394d2116eab277"
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
