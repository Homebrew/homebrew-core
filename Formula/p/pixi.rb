class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.63.2.tar.gz"
  sha256 "197d576d68e3bf1b0545744a98974b4b519393f2b223b7fb7270015f97381e83"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebf53b0725be4e82b800b0f3eb21f844999c3bd7fcbce2c93c2dd839907f739b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "442e8f5def7584f7801041a109e98cee3c137cb37f045cd098d06b720ad5460e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c026834bf616124c54b67d0d889610604b2da8ce29bf00207ddb38b9905bd19"
    sha256 cellar: :any_skip_relocation, sonoma:        "424276f718b0d497b049867a660b59c9344d7cd6a5e900d57732d303262db3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ade6ef5d7ee0d018043be09459f8cc08642d1fb437934365ca01da470ac6e14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bd97217a900a4714225560b76788bce61ede8d26b85ad0a6cea94efa60dd0cf"
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
