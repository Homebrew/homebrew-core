class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.12.2.tar.gz"
  sha256 "e84861c0a725990b6efbec1ec3be7cbf38352983871f8e74c3d42bc259a0a0d8"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d98d388dfe2b2af3b1888fa5fd4ec4f722b4e8fc09dd6fb5df45fc5e338f7795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577e003e50e2735ca3cde53b2a1b51938b26c01098f6e82b2c57293f0d4e7c44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a922f73ab00ffea950699afabaa91673fb0e88c9831123680a963138c6e24584"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2d9edd7488c0659e4b39d45f09e450bac870cea68204cac2c90c7645a6e4aa7"
    sha256 cellar: :any,                 arm64_linux:   "391cd9ba088a5b24372ec0613b7dde2785bf125a2b60b48f12b026720a1a4fb6"
    sha256 cellar: :any,                 x86_64_linux:  "8393459aa9cada1b4a07cd5b12e0f4faa53ed358e84b02f5dac621e885bab05a"
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
