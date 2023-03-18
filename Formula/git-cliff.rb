class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "26f05e4cfea07768d06ae92cd4b34bae786ed354089d9b5b1659d6408bf583c6"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e5dcb55037110786129976cfa7406f37719eceba17df62988f90c1a4470f6b9d"
    sha256 cellar: :any,                 arm64_monterey: "cb25e8d7b22715512441c6d99f42df5f97267ebdf2bdc70918198a3ab5f69c92"
    sha256 cellar: :any,                 arm64_big_sur:  "4ea6f3785a42118e97a008b0d897c8669032aeb7072d78ebb8e63b4445e2223f"
    sha256 cellar: :any,                 ventura:        "7c64d7d0219b6eefa4e7914de112a4665121b18f99d923bd563b80328fa8156e"
    sha256 cellar: :any,                 monterey:       "96bf1ea1fbcd777745f37350e308231b0447da4d40009ff317689d6d8fab8a22"
    sha256 cellar: :any,                 big_sur:        "6f0c044733ad84e49634c0306f813703f76e26f6c0f9bdc1af909bf403395750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae134bba4b70583342c6ebe59a19da904cfb35c7fbe2ee4d558c227bde45af7"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

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

    linkage_with_libgit2 = (bin/"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
