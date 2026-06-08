class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.12.1/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"
  compatibility_version 2

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32b6d82d0e742ceeeadac12c83f135257b3eb3053c3f8547221ddab7e2609979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd59a562b6a45f81410a15f699e844e72d0babaadc37c7ca56e3500ce07ecf17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "334f8f7cdc92f7c6863d1292d04f98e0842074d10cd8b0f5d5e02ad3c53e910c"
    sha256 cellar: :any_skip_relocation, sonoma:        "19561553ed2313f47cfe61a75ada2a252e8ea42eb5d3a4feb7708035dae5627a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c0defa1ab8b6ffb1040acdd19ef6765afd19cf3d8f829d654145cfae4423a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c7993750eb020e776213a76af530ecf7bdcd93542aac11997a3f82c07fb2de3"
  end

  depends_on "ninja" => :build
  depends_on xcode: :build # for xcodebuild
  depends_on "dart-sdk" => :test

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
    ENV.append_path "PATH", buildpath/"depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    # FIXME: Workaround for https://github.com/dart-lang/sdk/issues/63089
    if OS.mac? && MacOS::Xcode.version >= "26.4"
      inreplace "sdk/build/config/compiler/BUILD.gn",
                "\"-Wno-tautological-constant-compare\",",
                "\"-Wno-tautological-constant-compare\", \"-Wno-deprecated-declarations\","
    end

    cd "sdk" do
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      out = OS.mac? ? "xcodebuild" : "out"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "copy_dart_aotruntime"
      bin.install "#{out}/Release#{arch.upcase}/dart-sdk/bin/dartaotruntime"
      prefix.install_metafiles Pathname.pwd
    end
  end

  test do
    dart = Formula["dart-sdk"].bin/"dart"
    system dart, "create", "dart-test"
    cd "dart-test" do
      system dart, "compile", "aot-snapshot", "bin/dart_test.dart"
      assert_match "Hello world: 42!", shell_output("#{bin}/dartaotruntime bin/dart_test.aot")
    end
  end
end
