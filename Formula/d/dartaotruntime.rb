class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.11.6/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c054f2d5300ce770854225afbe9f2d8c580afea89c4e25efd4af233641a2566"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2164aed8e19788b8ced3d412a3ada024e1f199b0018411e16759480f289789a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bb3415f29dfefae1979948a3f05da1c74016354148626eaff10d9c219b6a012"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c6dce0fbccdeb79f4d7fbd53080073f1b723ec5c427bb8b2bccffaa456321a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a1077aa0af980837cc9d25d29339d313ab2d491afd8d8beb4b92ffc29f31c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f761bb72bea202529c42e397eaa21a4235ae6cc819e1ca0602bbd2999fe0200d"
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
