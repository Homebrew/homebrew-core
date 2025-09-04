class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "69952a39a1f89f6dea19d581b79141ef59987b391304970792546407d4af204e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e4cdf2179d74ff2871acf483be502f197782959f81420b95e891872ea044d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b4eca2860c2b97154044c8c885a2b673e6c0c114f26e251af93cc21c5f585eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79235ef2b237f73b56ca1f556bf2a44a68dbe30a3a6b195a12c65691cb26f3ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dccb8efef5fa9b556519bf66c7357e216f0527748a04a8f3cb29d90db3af806"
    sha256 cellar: :any_skip_relocation, ventura:       "9b744eb78f6a428e975cfa577aa67ebb3d80fb027f827e6a980cd205b80e1f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a2eb0fe4aae0431179d7fee1de7f5433c920a72cf974a9e16d2fa725726c92f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc70d94c059834bf6e81d06b48805e88b7d9cab0baa6651a7b68ec25cc7dcf21"
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
