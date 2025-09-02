class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "ce74792a4668a9ca0b5f99e6f03c41f76f8f3bd83f48224d4de2267de43bc627"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "933fd2fa088c0e53a5467a4b3d4bc905515627448a3f9ba5b124fd057d748f97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e8718b8ea968a0f7ca489e1e316fecd472dcbe46c25074e83cc08fc6e717e2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81644c159bedabeef121c076c910387a5dfc319cc7fbb0c0628f5415f451a86b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b9f91a97a3cd1d7ec1fae010fc225f0d86df0c3bb7a8369c43e49d03606fded"
    sha256 cellar: :any_skip_relocation, ventura:       "fb7c2a3e1c3d07aa7bb13fe9f6c114c01fb5d9de4ece3dbe5b2ee8b96d28f277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9366787d8a9210a96ed76a25c4fe3526b31f11aceed0f5dffa4c739ae56fb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00c2645169656178cbf516a9b42eb09cb58b707a459ae07aeeffd1832c09e930"
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
