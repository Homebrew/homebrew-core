class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.11.5/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b381e624cf828387c31e044d9a4d6340ce8d55ba572c007b0ac11b122f00fc91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a96926a2757edd3999f17d6179d2be9dde3093c18a7603c4b29c30f1aae75b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36463ed4b180261483d701a0eba52c0ea33c1e464c08a340c67b87f015c9478f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0973a4459bf6a41245fd3853152f2796586b7d4e857e6f4f6a0c03a4c0b5bbd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1840945baeee2a3cf2c1b86fb09ac075e0ac2d7f57c86bf1b9649700f69a9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff695b2219a2839231981e31159c936e7ed8b94cb30c8991c9c8f35b79545d41"
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
