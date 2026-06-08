class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.12.1.tar.gz"
  sha256 "75aeca0e067865646636ffc8cfd4f1763b29bc75692ae6ed5ee69de8ec674e22"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92d1c592f12900045dcb9e54114f32c908a9e7958e4d3fb544a39574ae7eae49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1945fc695994a2f3b78cb651a061ac42ec39435fc7d3826f7e0a43292ebb118a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6997d245b2cb1d8216a82f8638e0520f9f6be3be2f56d8915a54cd8bf1f42be4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f43dd8597d2bd5bfa3b02bd7f14761122069c25880baa9f0b3157d8cd0e6e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e14374b436c66662534d272769421bd71152d45c4785c59d09f0e943915e57c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e8663f0afd7902752a8124c3f457e8191e2327623aded8d41e12f27e004c97"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "b9d2b54daea64fa757df5ba737e611b691dc6201"
    version "b9d2b54daea64fa757df5ba737e611b691dc6201"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    # Workaround for dependants audit failure: Libraries were compiled with a flat namespace.
    # Issue ref: https://github.com/dart-lang/sdk/issues/63115
    # PR ref: https://github.com/dart-lang/sdk/pull/63116
    inreplace "sdk/runtime/platform/mach_o.h",
              "MH_NO_REEXPORTED_DYLIBS = 0x100000;",
              "\\0\nstatic constexpr uint32_t MH_TWOLEVEL = 0x80;"
    inreplace "sdk/runtime/vm/mach_o.cc", "MH_NO_REEXPORTED_DYLIBS", "\\0 | mach_o::MH_TWOLEVEL"

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
      assert_match "Hello world: 42!", shell_output("#{bin}/dart run")
    end
  end
end
