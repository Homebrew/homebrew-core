class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.11.0.tar.gz"
  sha256 "29db2d6db7fdbb90d6266bbdf2f5d9f587517bd98bc2a99ec0e1c20aa6dd0936"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff027cb60be130ce55464e87a8d2a0768e339c8da36e65536a6efa3d6feeb9d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b6abbc4e279ed0c922da5754ba4295882e13989624b20d3cd8ac78d788b7673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f273a47cd8a616ef78eb6055d487535ce373888254fd7cd766fa08861db3d80"
    sha256 cellar: :any_skip_relocation, sonoma:        "78dffaa4a58d21511a24a2d9efe9568a8675bf4196d6f341c718a4f8d54a4470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae87ddbb31dd728abc7b94848f83b29fd6b6637dd0a1f6d0ccbb63529cd8477f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4229cc7698b4d6ef0e6a76e9c28bfdd4399942da4516708f6b40470a53e804"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "06b875921815b3d28e6f739b2f31138a233c53bd"
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
