class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "3c130ebbd3121d3994ecd1ff1062220de610c7491ada02f9d421c8869674c386"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c05efaf75ee7ab7f098593bcb1850e7db67856b37a4bee8095be97582a3eaeee"
    sha256 cellar: :any,                 arm64_monterey: "58d2b4864149a94e45821249ce6942a42398b90f9b06e2ae930110869a56734f"
    sha256 cellar: :any,                 arm64_big_sur:  "82dc1e4505d418b87e73dcb5c549e371bc7b93788be56f78b3d81b235a2e5e6d"
    sha256 cellar: :any,                 ventura:        "54a241406d437bc2bca7fab7d39ebd00e5c818d10f9a1732db901a972f419966"
    sha256 cellar: :any,                 monterey:       "beb081b8d5063d21d94715fb0177e3a55833742b360856a8d868d06bd2f21902"
    sha256 cellar: :any,                 big_sur:        "60a41e3cd6a44e2aa273fc46d8b51d77875eb4dc783c5973b00d3b258862aa73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2d66d88c44e6e6479ac337a3151be89936bbc4258c194c53a3304a3ddf3bb7"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

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

    linkage_with_libgit2 = (bin/"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
