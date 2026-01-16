class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.10.7.tar.gz"
  sha256 "4d902a7b01edb1677fa47a178f08e33895674484bb3154ca97b3a4ec23afc09b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc2ebdef545d048b15afb8baf9b105cccc71ebce14e7e9b484b0310ebecc90f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dcc965c7d9018bea4d5dc1108074a1164ed13a2bb1d6357d322f542e329eaf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc07fbb1816896dd36889b18ce62c10cb426d34a0512cc3b757d591e5261136"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccdc29fb17b47c49d71ddcaf87c90902586982940e1cf33330d045b3d1aa0237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d11cfa339857b22d3a5cd8878cfd5cf284a6db1d2203a43e8d9ce98b248f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b01e52966d304acbe428f88a7ad045b45a5f2d564241e08bc57d00b933806a"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "967382fdcd1477dab3a7fec8eec3e3d5368bb0fe"
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
