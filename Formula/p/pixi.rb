class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.67.1.tar.gz"
  sha256 "1a38eef962d0e4993bfe34943b68ed1c190fb428d74c298f6fd261b95961d9ca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04b64748059d6b4bacef49781fb13f48caba568085d27984437029298fa47684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aae3a26c2c781bee4d7c41fb63ea5c2aad071e94ff878ea43165cbcb6fc0df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2fe4e079d817150dade524c378f8d86494e4f204279a80a0ec7740236a10d97"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ef98796a9d968fe216169eada40d05b9ea61e52344b431ac5397d7555f825cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ac5145d21a4c294a63af8c65ef55852f307295e203c5b8034f9fef9357a9e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcb5b99afb1d783db5d69ba1d1fc2c3e7963895dfcddbe9172e4a344b21d0f1"
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
