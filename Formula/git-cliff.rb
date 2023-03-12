class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "26f05e4cfea07768d06ae92cd4b34bae786ed354089d9b5b1659d6408bf583c6"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c08ca9f5c00f3baab1a60a19eeaaf73ee7f45e8e1c26fa67b9bb47c37bae45bf"
    sha256 cellar: :any,                 arm64_monterey: "27be94c69e032f84359cc08d41d48871eea8314f10e26b41d476e34ba90d8709"
    sha256 cellar: :any,                 arm64_big_sur:  "d35d6f738bf2fe0c5356cd31864281d916065d17f81b975d2467a034b247fa46"
    sha256 cellar: :any,                 ventura:        "fc9eab446ba8ea16a5130b328ab0e63b66ca235203858be192dd875e62f35948"
    sha256 cellar: :any,                 monterey:       "30ca3297bf40e449fa42542a033e85117ef9c4ac931535e2bbf6b195d61b9a95"
    sha256 cellar: :any,                 big_sur:        "5bd60af9b0798824bcffb767e501e30f92fc2c33c7e7c6bdd29734c14a36e073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91b344b9cf48f8fbdbb8454165f190c637400e8b692ba2af91c4a37bfacd91a"
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
