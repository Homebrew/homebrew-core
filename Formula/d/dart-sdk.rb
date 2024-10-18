class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.5.4.tar.gz"
  sha256 "c6bdf7591d3ba8d353dfaa0b10af58918610e65a1de9f3c9a644e7f3aecab16c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2a56ec4b2d5b27bcd00d78d0340022d2858a5038aec37b306deb7876a07c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc2373a8cbeb791c5f222b93f92ffc468f398d600393d12ad270f242396183b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0e7fb133d077e1b18c0fb2f15b4979ee88003b828e357ea93895ccc1abfc73d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ddbb564a8c47661d3b2417380b728a7c44c8a28e6d45076265b7d49f7636a1f"
    sha256 cellar: :any_skip_relocation, ventura:       "283de9b8ed745c6fc4d4fc81ef2d9464a23112af17ddc0f8975ca08bae25d76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35604178437c7d8a51e4ae3b3bfc1705625c5916e17893bc1f780d76d020e669"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "c4d75a151973a872ec74e33afb90acde64c48644"
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
