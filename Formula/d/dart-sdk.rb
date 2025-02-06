class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.6.2.tar.gz"
  sha256 "bd2a2d650cd4dd41da889b0c17beea866401469536f312c924489ccc6607ccee"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b613f5f633a31f1415d34fc9feca22e8088cee53fb40710a62cfd748cd5c411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28dfe8ff43820ac67492fd810d58cebf5b7c722454da14fa5019ddcf1edc10ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c2ca56882a1e559ebaf194905980eb86a11745346eacc0a09c16fc23cddf5e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b40ba6bfe0df04e96f419d577ee3dde085c8ada5d79dcdfc3967c5819dbfe7d"
    sha256 cellar: :any_skip_relocation, ventura:       "eacaef4619e305dd62d66e15ac22e89c84cbb5fdbf04586f94f4205114776762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e49bd8882b500a50d78e4b95b4bc99106f42a8072f82d50d2266a0c33950a8e2"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "ce598256f20f74a5b9e321bda2ff60edf280ab10"
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
