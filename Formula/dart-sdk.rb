class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.0.5.tar.gz"
  sha256 "f5d75042e7b3081816b19dcee196885769420e0bcbdf0ff3c32e5bb4896ff9a6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac3a62189a9a11ab1e2e5f4facfaa49e991365f4af9e3c1a2329ed06ca5e912d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c66b990f78379e99d66ff788c88cb5d63348c92ccafa605ac8b388e77fb72009"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca43236135bcab826ccfc23e5a63ca39fc581929aaf4c4b1860e8fdf2d540887"
    sha256 cellar: :any_skip_relocation, ventura:        "79f2881930a861362722b90cfa9325a49ebe7a06c1bdbfa2c1cbc6652336660b"
    sha256 cellar: :any_skip_relocation, monterey:       "cf7ecbbab6f88b94ecb6f35939afbc6eaea896d0b04bdd22bf8f969605b41a5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee84696a1e18f6371755fd07a8036614670fe0a1786504d6e6d99b1f7e42e02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b0e5ae8e7bf044fea43557629f0f69e6a3f7edf8d139ca3c8ecaf9bfceb9962"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "2b19afb82030a638f8a3d8f592fa25269b924800"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV.append_path "PATH", "#{buildpath}/depot-tools"
    system "fetch", "--no-history", "dart"
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
