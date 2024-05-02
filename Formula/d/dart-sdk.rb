class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.3.4.tar.gz"
  sha256 "5e59f6b3994eb2caecde32317d5915fb7207b101fd18c5897c621335820761f8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24d61fc4314b0e78b9dcd4d03c18329704386488cca6f212f9f20bf760e940a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8d54384d30df43e2b4f67b20049a907150b4599865e87512770d84f8d528515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b370b69a33aed39734d6a92749f524d8ccfdba00a91110baa2c96dbf6aa19ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "a212fb35ae831e474832a525acf186d890dff9735c84c683e244298146f71376"
    sha256 cellar: :any_skip_relocation, ventura:        "a5f0597d1c48a0016a2a974aa8a826e99f3d5b0b40615625e293e5792dfbd463"
    sha256 cellar: :any_skip_relocation, monterey:       "5915d28c5995271887d126888bf17f1279e3295df027e93d43a1b3f7a99e5c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d548cc3b3376d3882fb2d0fbaeb0a3f847c561f70036e6761671980a3d9fe44"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "332c4eb546eccaa4fa1a524d89c9c82194b8b998"
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
