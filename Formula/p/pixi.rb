class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "efbd86f9983490d5636035d9b26994ad3df0d71617e6046eb8e9d5c9742e4166"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab5657c0dc4eb89fe52eb1b2661d18ca5b37e845223f26b1a03df8a46bc28aac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c01ef591cad53c58a5579b0f4ca7d48d616752d7e22c0ffff7bfac382ba73a09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "139d652d845a237a731b72b2a2cfb9f0282b55a7199c819eab3ac10c03703c07"
    sha256 cellar: :any,                 arm64_linux:       "367f388a264a09ff413eace364076bf1b7f75355d0d60b790933861ae75a7f8e"
    sha256 cellar: :any,                 x86_64_linux:      "7f0dcb50e3b623223131fd1a15b98f7d6ed5fc4b474c2d1e377d65cc48f58b6d"
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
