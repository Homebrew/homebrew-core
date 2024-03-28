class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.3.3.tar.gz"
  sha256 "ccfb6a4b6ad94e0015d05611273bb747262082fefef86e537ccf725a3ad6bed7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6221fde99eea40f012ab3a80fb2aad155621da3bdd8e9f0eb84595b227869bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "054ac38f7c82609afd621eb8f21a3cd3dae2478bfb87f9ca04ad21553eddd374"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae898176ffd0fd44cf578b742fe77901fbad8215d840b9295b608a5f2ff25247"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d55073bb552df64c5bfaaf3213ffdb5e2265f2228bbb289a9832dbc1248ca7e"
    sha256 cellar: :any_skip_relocation, ventura:        "37590171808cbf77ac42bc1ee2203a50c11766689407bb07e3cd34ef879a6708"
    sha256 cellar: :any_skip_relocation, monterey:       "d41c6975d5bfd7aabf2ddf658891dd3628def858e9b96348180fbe943a0168c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33d2a818940dc8101fd761a941629e62d875588b75e96786a18d156fe7c8db8f"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "79cfa048c0e66e7a9478f4e993aadd3873cc1fd9"
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
