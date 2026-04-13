class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.11.4.tar.gz"
  sha256 "3f96cd6bfc2b1fcdc6f512b5250e99ba14ead0c6d61f087f42197336d8eab5dc"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3de15fcf1c8414f305c703d0653f5eea64cb9200b61080038b93a896ae53cdf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028d51c9e3ed5b54d7b43671db16652ed651509f816b5973eb0352db0902b369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08654fb65125dc56fdac8594da4918a51825e0839b7aa1420f206410a75360b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1288c60dc4d9398f759c0fdc20ff760d6202ab1a8cc1cc2ff44f30dbc9403b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07993fd5d586e7bdf7dd8743961232665ec31ecc96314b2b7cca77b49ff1b8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c3a9a04bab93eea472fc120130a84ab12fb25b89da811ff0aa493666be2d6f6"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "4ce8ba39a3488397a2d1494f167020f21de502f3"
    version "4ce8ba39a3488397a2d1494f167020f21de502f3"

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
