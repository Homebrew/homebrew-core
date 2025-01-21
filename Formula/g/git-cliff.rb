class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "7b9a74f0871983bf5c326ffd7358ba46925f14a6feb1638c8c1e5d6b36448eae"
  license all_of: ["Apache-2.0", "MIT"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0b3c51c4e0acf10cc05d274fe62490f4f71480f304fc99d367ccc05405f9871"
    sha256 cellar: :any,                 arm64_sonoma:  "ab69ab2b69d6ced04fbfebfd58f7c0dc8846f9c177398fe00711ae1f9589c5c3"
    sha256 cellar: :any,                 arm64_ventura: "e8087d7374b0e27975691c07dac781330cd335c14469510c03812ef466d94f34"
    sha256 cellar: :any,                 sonoma:        "f607863bf8a829f4dd905e90bb66e01b1b6ef2c2a1bba1a3f2cd63abb9b45b88"
    sha256 cellar: :any,                 ventura:       "a11a9463dd9f4b7527747ed0f7bd32bdc55672d484bd8f762d4638bcea7edb53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca33fff18fdf624befd45cce3bd2e7ce53a7040bfe0e2c5fddd6d53e55620c5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  # patch to build with libgit2 1.9, upstream pr ref, https://github.com/orhun/git-cliff/pull/1002
  patch do
    url "https://github.com/orhun/git-cliff/commit/ff4bfb112d7ac72cbd759718f6fc96c708684f4f.patch?full_index=1"
    sha256 "647235c0db29b56bb54c72c3bf89087bdd0abfe96a65773627d0937e323d1bdb"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    # Generate completions
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash" => "git-cliff"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"

    # generate manpage
    system bin/"git-cliff-mangen"
    man1.install "git-cliff.1"

    # no need to ship `git-cliff-completions` and `git-cliff-mangen` binaries
    rm [bin/"git-cliff-completions", bin/"git-cliff-mangen"]
  end

  test do
    system "git", "cliff", "--init"
    assert_path_exists testpath/"cliff.toml"

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"

    assert_match <<~EOS, shell_output("git cliff")
      All notable changes to this project will be documented in this file.

      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    EOS

    linkage_with_libgit2 = (bin/"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
