class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "a1bdf15b861b63d2a7d12947980e415e35d6ae268194b4c09bb765a406fe0259"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61fdae6bcf25d9d0f0dc4a115d1f318cb7797b6d076f9f56c9c5ce15e3b3a23d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd6f42fc9aab2115fd0cc34aa50ac71149a74b469558ca192cd28be3cfe238dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ab7a204d1da6c9917f9b1b733222a1db66b7d92f12496f415786bb378888389"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbc475fb568f7aec4d093616c882eacb2248eb7a951221e91239a98188812e76"
    sha256 cellar: :any_skip_relocation, ventura:       "729d89ffd6c09784b93fb9558553d420f4f1e70b0076addb416e6c8e199022b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad0d4dd9eeedb704bbffa7accd3ba5ef84df40a9bcf9a1ad71bfc5705a1d32ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bbcfe741234910c8a70674f3d8091610fbdbaf5e9a657a5be0b4281c022d4e5"
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
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
