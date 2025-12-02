class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.10.2.tar.gz"
  sha256 "aff66a2dd4a7dfd95ff2be8c705644ddad3e8cab9c4c464c6fcfd13d9473e51b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "067bed994e944cfea5c601f0f47d306df1254d2bc70d52de28b44ec5e2f12de1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4285eff65acfdf605d36f8030a3c970c13f2bdaad031c78a28f524ec37e6a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7402fe17d15f93d0989dcaa413106844a05f798eb9da120afb63c1e74696992"
    sha256 cellar: :any_skip_relocation, sonoma:        "931dce188d3dfcd0f4c4f09bc57078aa5931b4cc15ff5337f057488ae96d71e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "651f6e9359afcd3fb70a2023e3645e17e6d3093dcded88ea74c402405fc825a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d4f4059650e3c4a6df2515b1aa59618eec289a9d94da0d98580fc88554f7c81"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "8efa575d754b8703d99b0f827528e45aeaa167aa"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

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
