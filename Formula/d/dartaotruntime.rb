class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  url "https://github.com/dart-lang/sdk.git",
      tag:      "3.14.0",
      revision: "fa8c1270c374c1346931583a17c3b7f278d3822d"
  license "BSD-3-Clause"
  compatibility_version 4

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a197db36d9b1ff12056ddd153fdbc4c2ca68c14ff94622bc1bbc6748dae18cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a344f901c7f88195628eeda138bbd0b915d00e81ee254e98437fd45b0a46c89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "874b941afb759d70cfc78a841660d30bd7d60377544083740d5fa12d2d01a2f0"
    sha256 cellar: :any,                 arm64_linux:       "dfdd7704c20d2af5c486ff911ccbb3b66130df68bbf0451f1df987d3f8a27b36"
    sha256 cellar: :any,                 x86_64_linux:      "6056c0b807df47fb25b3113eac4a39cd4d35b90b1cf401a61ce1ad6b441b1024"
  end

  depends_on "ninja" => :build
  depends_on "dart-sdk" => :test

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  on_macos do
    depends_on xcode: :build # for xcodebuild
  end

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "43956b3e74de59b07bf8931ba9a472d622fe86a7"
    version "43956b3e74de59b07bf8931ba9a472d622fe86a7"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  allow_network_access! :test

  def fetch
    (buildpath/"sdk-src").install buildpath.children
    (buildpath/"depot-tools").install resource("depot-tools")
    mv "sdk-src", "sdk"

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", buildpath/"depot-tools"

    system "gclient", "config", "--name", "sdk", "file://#{buildpath}/sdk"
    system "gclient", "sync", "--no-history"
  end

  def install
    cd "sdk" do
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      out = OS.mac? ? "xcodebuild" : "out"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "copy_dart_aotruntime"
      bin.install "#{out}/Release#{arch.upcase}/dart-sdk/bin/dartaotruntime"
      prefix.install_metafiles Pathname.pwd
    end
  end

  test do
    dart = formula_opt_bin("dart-sdk")/"dart"
    system dart, "create", "dart-test"
    cd "dart-test" do
      system dart, "compile", "aot-snapshot", "bin/dart_test.dart"
      assert_match "Hello world: 42!", shell_output("#{bin}/dartaotruntime bin/dart_test.aot")
    end
  end
end
