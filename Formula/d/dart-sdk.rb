class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.4.2.tar.gz"
  sha256 "8721b08222578036780f0894eeab83d9d7216ab93c11a8621fffbb9ac115013f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a6ff5accb50f13768808c2e2261a239d41a4c28573eac488b6dc00bbbc7c1f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0e51b222a838c201df89ba6f92a9546a285c5f0d61c5ccc99bc0438e0c99b4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a2def2298ba07c6b4b14763d6f48ad952d3030ce9c6c78f3492a4666828fcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3b27c56a93269d4f0a56e5a060ce78672388d8248a71a6f598be7e3bf279648"
    sha256 cellar: :any_skip_relocation, ventura:        "2bc67451c51ca5cb6cdde6f20b73bd057070fe0be90d3be34cf0d41c997298ca"
    sha256 cellar: :any_skip_relocation, monterey:       "bc85d4c02232ecc79d6ae583228d50e8912c1bd430ff41252d6991cf53e50430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec0ddd606322cac3403affa94577c0dc38f9df272ead4c460265fec29adc5e3f"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "dd0dd629970c7f64aba9a32848d100aac4e185b9"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--no-goma", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.capitalize}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output(bin/"dart run")
    end
  end
end
