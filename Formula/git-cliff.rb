class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "451db5e7ce904f33cf5772cd67400015829e5b7b3d18955bc3e8f88977b63793"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3001a6dd172989dee4f9b92dc0795f34e644daed41c9d54718237da1585ff2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "258a387caabdd9a492b71b54c82560f1ba49d0348cf2a04196b7ee4f2f766cb8"
    sha256 cellar: :any_skip_relocation, monterey:       "39e4723dc10d5cee07b6dbe973f3d58be72d4672c473bcbb644863f4139d3a3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8255ca7d405396e579e4b044d3145aa61f5f283f283cb532409bbc020224ae5c"
    sha256 cellar: :any_skip_relocation, catalina:       "a3c5b4cd80793b2d5ad86c1f06ec19d01bf90c835f077825b58acadb70004294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941e66299ea2259f88244cf1a56453e3d7af30e1ae9174eafc3ad3f3ebba0b27"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")
  end
end
