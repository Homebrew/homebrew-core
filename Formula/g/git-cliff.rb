class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "49c26101ce1f834c1149fd7107e6cb774ea38410afe9cd5c8f35e0cdad417928"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2f045e053a9c8d4cefbafbd92d14c872186ca3f4b935a4422394936ce28f439"
    sha256 cellar: :any,                 arm64_ventura:  "728171ea5d52f3376764f26feacfbee014d7ca74d422b30597ec892688404fff"
    sha256 cellar: :any,                 arm64_monterey: "6d37b2b0dec1dc44d00fc4a2506baca454bb183da55e72b2503f99037f4bece3"
    sha256 cellar: :any,                 sonoma:         "3cc1cb86f26f079eb12aa861698e57fb9daba4a42c8656d4f7ea3c8549f8e61e"
    sha256 cellar: :any,                 ventura:        "20becedd2d172d42ee0b4b65f3c9e7602d868bf2b9a77476c2cdad57a85e9499"
    sha256 cellar: :any,                 monterey:       "cd686a302fa3b91c1af355b2091d944e7952eefad0159fa3ac95a76db8466fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc7fb9ab9b41375fac34ce656a14258d6a8fddaf73652f00d26d74ebc686bc4"
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
