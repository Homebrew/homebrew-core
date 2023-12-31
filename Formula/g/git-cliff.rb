class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "8ec9a2c9cd0e97a8111a82bcf2fce415f40818897bdc76a2c5cc63d99114ec30"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "860c578c40f61ace2cb91a18012ba7a8af7806be08f338cdb591e1d52b82ca06"
    sha256 cellar: :any,                 arm64_ventura:  "0ad0eb3b0662c90820d45c3f06d47ea959551cae96cf7d71bfc0ebb0611d5fe3"
    sha256 cellar: :any,                 arm64_monterey: "a08586ac6cfb1901d89209b487ab4b5eb66e54bdafc334e5e29e087ed6159240"
    sha256 cellar: :any,                 sonoma:         "1be7a2a7465f9f230232afd4a4bb0dfb20d1bcc96489a43561918b3b1889f6db"
    sha256 cellar: :any,                 ventura:        "d7efd7a6d669949a91bf05ac86870ab016cc607b0b77c2fd8818f67ddf0d5be9"
    sha256 cellar: :any,                 monterey:       "71f9dca3327915bc870260a7fc210f6e0660bbba2ab04324bd69cb2f36a16239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b3ebdabc943fee8f4ec71ec08edcf5a5922d5f248f1db286c499c9d219bbaa7"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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
