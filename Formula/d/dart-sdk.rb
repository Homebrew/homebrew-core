class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.11.5.tar.gz"
  sha256 "0e7029c6ba63c45a43357f5f3e8890f6798827c1433a14b92962f8a688afdf6f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec92f51ea1ad125d6c7d71243a19a329d972668033867347518ac6983dbe8ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf95fba3922059a150a9d0b5ba88164723d1658951702fb42872b978117d4aed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e277c084855cee60fb7d05215f57ac348e3fe60fea2602aa7fe9ebd2a7557766"
    sha256 cellar: :any_skip_relocation, sonoma:        "2832b913d71cc14c2c63cea01292fec45b7f270e4bf94223d485cc97a91179a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e25bd1bbe2ca739f75ff6bb53765cbdc58c10245b9bab31def9ece1cd94f1829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1ea971433e619dc9fc19e84428b7b4813d895da6890b69817815ec7fa9e817b"
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
