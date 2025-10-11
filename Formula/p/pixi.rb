class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "526ce8b351cf28f22d4b37d10ae01e2499d6e2ba39a410c81d31b0276a8bf5e5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c14ae12227c6f9dc2634089a48933cecf3c6231225505a95d1f44bdee219538"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecdc4c5b3109b9d7b7e45e6120a2330d5a072b9a2e694e196217fffb6c46e9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5da84e2ae040a4eb28cc33e91c3d74063b3339189f54dd34cee91e91523bbec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "35febf878e8a0a6b881619810b11347b71dab80435c20c7d98e313bf096edd80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e898542d8e868c9801920216dc488a25784cbdac6cf73b51b08c9b91d4ba2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f7eab3c024e7612f7685a5c2385a280d69404caa8bd5c95a0ab5b484ec21fd"
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

  def caveats
    ENV["PIXI_INSTALL_MESSAGE"] = <<~EOS
      By default, binaries installed by pixi will be placed into:
        $HOME/.pixi/bin

      You may want to add this to your PATH.
    EOS
  end

  test do
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
