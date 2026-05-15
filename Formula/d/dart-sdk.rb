class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.11.6.tar.gz"
  sha256 "107d24efcf88be96ceea9045465bc4c6f90a230d09b48511a45447145db01946"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa1a7a1fed0fc1e45100cd150f216d628e3b4adaef2e3179489fdfe70830f28b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e614dda7ccce558bd0a4d0bcd1afc45da8e5f5ec42f68b868eb251a57c764c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273e37381eaa45041d40ad962b9b628e0ca0d7797d9d7790eaf988aab6173d00"
    sha256 cellar: :any_skip_relocation, sonoma:        "da4b254c7ad3ef401a61e626bc53d3a5452c1abbd3c64e420b4c3ba204d9a9c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5cb46426872b161c7b69b32758cb72800317f51214e12752f03aefa0976394e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87a03f33559d69cfb418b7d682da15af9ee5a5a019ad074bb2a9e9e056182ab"
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

    # Workaround for error: 'readdir_r' is deprecated
    # Issue ref: https://github.com/dart-lang/sdk/issues/63089
    inreplace "sdk/build/config/compiler/BUILD.gn",
              "\"-Wno-tautological-constant-compare\",",
              "\\0\n      \"-Wno-deprecated-declarations\","

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
