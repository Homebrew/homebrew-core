class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.0.tar.gz"
  sha256 "600ac3fb8276a164ec8ae33f55b3c67816a9a4cbe30cf8b0173634763e536936"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd3aab0ce1239531584f952340405e9c886416a6daa7a830d9f56b7be50bd803"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e16d269ae9b972c37db616f6989759457296ae1b192d8610093899c6baeab33e"
    sha256 cellar: :any_skip_relocation, monterey:       "d84793a2434985bf59535dd71ee452ebb662e7970fa8b40bfc6a4c1a35f1d518"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fde24ebb8f4eba29848fd03c577dd881687adc272f48c4340e6bc9bd7296651"
    sha256 cellar: :any_skip_relocation, catalina:       "22c111bdb57043be2e1d0e432f829a61839a1270a6564476ec77cb076ad356bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc61e006f78c2f5cbce5b9a4463935cf34a3ac0f2d73b7f752c28c87b424d4d4"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "138bff2823590b3f3db440425bf712392defb7de"
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
