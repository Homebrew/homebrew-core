class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.19.2.tar.gz"
  sha256 "30f49ed47a878834621d6703076b9fefab6390814fe6ff7cab2e19f5fccedb60"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d88f2c775ad28f1cc1d9050a63a9d425b99f591ff36d45f69b2a1ad1973501d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb20f4df880f5305b6ec31ca4b41f1bf0d996a6ae3d685b20a7294c2fbc3cd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d4a4b19de49aa8e5dae68470c01fa3553723bda31eb3012ed0d1b697798f1a4"
    sha256 cellar: :any_skip_relocation, ventura:        "26f2b10505175317ce239f4596102aa2b36b6bbd809b7217136d4606095cf863"
    sha256 cellar: :any_skip_relocation, monterey:       "1ef708ca65e0653a8baee86c1b8add2fceecb64d80275006222758817299f5ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "113a5bbf2e0335167ce8b91440b976026aa5e23a14f6de2482d3277a9dd4bad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303b374d1203435de95f733e72f02b19580d04f045cbeedfee82cce0aeeca944"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "d8fb7c966777733491e11037dcdb2bce1c16662d"
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
