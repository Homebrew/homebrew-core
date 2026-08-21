class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.13.1/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10b2d1c7b734a6842cf29dbee6a81c8432c6d2091e76da41f74f0595ec859eaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f94851c839b1ad390c31b7eeed919d829e2a703fc3f2a68309b323972ba4ab54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "259e6ece2db65062eaef102ac5d60450660d6d02b2dcd28c972c5fa9d3e411b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b1486251df5e488e4451f0fcba80c978618eacf06af1abf8f70f205f1bf5ea8"
    sha256 cellar: :any,                 arm64_linux:   "9de1f0c573f99be85a83fee02637fecb50baf99cafec4211f3438ffb794420d2"
    sha256 cellar: :any,                 x86_64_linux:  "5203b1a6b6ed645b460943afbc6273f04de48c97c955e77b05a915ae0279985d"
  end

  depends_on "ninja" => :build
  depends_on "dart-sdk" => :test

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  on_macos do
    depends_on xcode: :build # for xcodebuild
  end

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "8ff4a322a17ea014561931720c8153904cd0a9c3"
    version "8ff4a322a17ea014561931720c8153904cd0a9c3"

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
