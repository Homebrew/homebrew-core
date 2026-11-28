class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  url "https://github.com/dart-lang/sdk.git",
      tag:      "3.14.1",
      revision: "c8a0db5978a68d4037f7e5294ffc79867935c8c2"
  license "BSD-3-Clause"
  compatibility_version 4

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    manifest_sha256 "457599016fcf03d3c0b3c1fb968db162c0baab63c3e21ac3041d8fff5b3c659c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df95a0a870f34aa4d641516d406b5bf9188b6f4cf00ee75f73c4e4ea85469003"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2338a3a79090297210540f47bab8f8736cf094c38cd68674cedee152172d62b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8724b0232682d7c0ed78378a8542c4a9a07325172c2fbf668b4f240166139dc"
    sha256 cellar: :any,                 arm64_linux:       "535dc7b89899f61e7150731af3d88b5efd70eae4d82d45bdc7a8860cae035c4b"
    sha256 cellar: :any,                 x86_64_linux:      "b2bd018c0b6d52a26c82d4c4c57401e18cb3eec9a1ff53d47780e0948c361544"
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
        revision: "ec77017fb3e090ff02bffb9c6980ebcdd3006ddc"
    version "ec77017fb3e090ff02bffb9c6980ebcdd3006ddc"

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
