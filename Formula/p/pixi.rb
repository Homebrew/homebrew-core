class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.77.0.tar.gz"
  sha256 "afac93f0962e801aa5f9523d315170128c3b0e05654c68c62d7756fd874cddf4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3c7ff29e5d1718449a1762a71ce37e350638a9f1e3b0f92b084cca2639ddad0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e17110893f3ee369813c47f0e025afa1722fce212cf4d2a377ed8740395f4053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98a0108141dd173d81fb72988634dd666886bbe77116f3e501509a434d377673"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ce7fc4a7ae754de5d47091726c5d58310dd25865d5157679e01ef6de148f88c"
    sha256 cellar: :any,                 arm64_linux:   "fee6a230abcaa1f23dd8d81e449de969d3c6581903ab1ee5fe9ea91e75f23584"
    sha256 cellar: :any,                 x86_64_linux:  "51c701dfaa8829a2d0bb7b6ec5f725ed280099f533c854473031fbff321a16e6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz" # for liblzma
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
