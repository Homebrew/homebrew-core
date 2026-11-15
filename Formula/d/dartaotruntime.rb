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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5c60fe4ac61abf52518ea014cdc42d832d5f475603bcb28383a2d274f9bbeb24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f59445a168d588e4061dc1a87f1c5782ae539089e62917792aaa48c9d2d66231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "749b8f5b23140a5913c0f93b3417ad125393dfbd3f742e99588af51a23c03bb8"
    sha256 cellar: :any,                 arm64_linux:       "f430a80581fba78197cb30557fa582d07d60664071a8243a37d9b8cf3b99c348"
    sha256 cellar: :any,                 x86_64_linux:      "4133f74a8383d861306a1167b6d3f30f32c255152bf30b881017e0729cb74ab5"
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
