class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.3.1.tar.gz"
  sha256 "07ee48063e212c4d1e5c7b6db762df7297428b497048ef60884c1e277e49273c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2012c0c4b77e16577f531ff5c970968d52c688646e7ddf6d991377f908f3463"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "902b688752a19a1d1ac72c0a0cd11e350f79c07f2d4702ba1bfc933ca7b1c369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c891f206788b8cd69b65cc14b7eb86b40596322c5e25fe272c04b89febc52cb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "82ee197b6a4b8c1ea1db57fb53ba9c3dac46986b1bd6b7042243ecb0c058b215"
    sha256 cellar: :any_skip_relocation, ventura:        "db782af4c72cc85e0d45dc585d8504b5672a28e057066f7f0fff606d49f17056"
    sha256 cellar: :any_skip_relocation, monterey:       "365f0092708f0aa86f672d5497153b65283a334fedeb4fe289b672e17ec05407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "badde852ad96b3cb70d48f6ad79545a9c55d50b737550f12b82bb9072a6d05ed"
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
