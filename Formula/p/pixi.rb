class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "d3610917b2b952ec3eb87c7a9d7cca284a452c8c6733bab8016ca82ca704fc7a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c25c6cea42fc1aca0a4f51ad644b2b73ed7f683fcacb20e1498f1eb72cc654b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f9fce887256d61dd48fb43aacc61c87d92279f8dde1590c1c29c510eadcaf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb60ca60d5de96ee4acb3c8f61cd2091afbc2d781cd7cdf55a1f7dcffb38fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "38209e1777c6d44d9f333b39d3179c06153052ef69dc664fa5bc3d054ac33057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aacc1475319c0607a2e8d8048aca17d00212bb46e169e55adedd592c4d79cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854ae048388dc43574ff24f199e511e55d70250d0a6690b4e35911549de2c209"
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
