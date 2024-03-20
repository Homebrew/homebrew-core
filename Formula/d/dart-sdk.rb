class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.3.2.tar.gz"
  sha256 "3a10617bca2a6f9b4070a409501559ea7f8cd2b1add1a9cd718821045ea5013e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48675af10025319fa5ccae0ad9bc3126bc2ce8bdd39c9234f12bda3d6eb2eacc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b161fdf08d3e85c76e365632ce1ade9a2b1894c09980b49ef3aa904d77ee61b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ff4aaefadbd93bc4c8317e3714e77b407544ebd85583030540a98fbc543c4f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bef2f4e7ead963420dd7f4ea38710b7a3f90a28fb7af0dd87969cbc1d47e923"
    sha256 cellar: :any_skip_relocation, ventura:        "d146b62ff39d0dbbe9b583cc139eaba3a4909a20afd159b8ddf8939f91be7852"
    sha256 cellar: :any_skip_relocation, monterey:       "9a63bb865bb280586bd654021927ba9af4be8cff94fd706cf9839dc9d8961743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc60498e9c09d8d75ad9051c247f1a81738164172185af79ffd1bafc4514c96e"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "1382a3f980bd079c6529f8bc2ca6a2acaf300789"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

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
