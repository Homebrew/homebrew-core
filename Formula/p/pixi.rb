class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.84.1.tar.gz"
  sha256 "134143de3fb7571adcbe85235429a6b05946c4f502e6b59fe5460a5dfdb33b06"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9b6c4bf9ee66c5632d3ac9746ff2ccad9f4066c5695d721bafc74cfedf4e70c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "202e36d9576d36c1b9db64fe7c88b2924d8d6cbeac7d816c371feb9c4097cbfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad8ae988ae9987a875a49a0db6bbb698df81d949eaa6e88422a37118e9150e9c"
    sha256 cellar: :any,                 arm64_linux:       "569e1fb2dc31ecc04857cc0fa8f011b8838efb7135251a893314c76e1a44f789"
    sha256 cellar: :any,                 x86_64_linux:      "c0140560ca8ee97e27dd0c16dd22e262721c4b2208e836b59636eed60809389d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz" # for liblzma
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PIXI_VERSION"] = Utils.safe_popen_read("git", "describe", "--tags").chomp.delete_prefix("v") if build.head?

    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args(path: "crates/pixi")

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
