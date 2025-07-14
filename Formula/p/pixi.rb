class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "0625af192f09f7b1d905b207249979fa9f95d46d6582e7b83d46b49db652b978"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647baf6f57782b9be2b67ea0f669ad5a5c6dda0ac49d571aa7a442d406871ac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da6e63f11220221af8119e15e42ab3fdeb5a0b91b24be12404bdf18daf09bcc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a40ae23fa56d1c387f2e211625810591020de263faba6d8bca9c299725edc85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "06246576df0a4486bfe945557ab8d7611fdbca1f2b074e19f81434257ef6e3d6"
    sha256 cellar: :any_skip_relocation, ventura:       "633b297e0b6230e5e29ba2aadd26ecd756619b17083e1384b2fc588d28bd09b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "388e8c99b5ab60ff4f41e42258e4370e005fa617067b2214f9d6280bff5a11d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4ff1791a45824084b4360c2282ccf44251258c8d47979f9b3339deb230647db"
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
