class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "1c321b180b071ccfa8986931576fc02ca4dbc75dff035e4c663c2cfb8ecd4683"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "61ac163767c260e569433e87a1e30b6230df93e41f0bde2cca46f6a59ffb522c"
    sha256 cellar: :any,                 arm64_ventura:  "c65a52cbbdd2dfdb4862796a2e30a26139732d27c5c690a2692b55e5997bdebc"
    sha256 cellar: :any,                 arm64_monterey: "43c61feb45cff2f3079a4ca6b16dd405dfd32bb5dbbd965898c03ab92d0cb4c3"
    sha256 cellar: :any,                 sonoma:         "37ccac8bfc63dd7de1611e62ff31e24d9e256fc8d97f2abbbe58937187807454"
    sha256 cellar: :any,                 ventura:        "0e809293b5e935c67f4fbb633f4a389963121a669af8ff3e591ed38ec1e7d46b"
    sha256 cellar: :any,                 monterey:       "ef43913de1b458bfbb8951390858b95a633149ee2320a48267a4a2795abc1719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e07083289c3625e9343f121b4626c5d16e1454a426e2f19026f04fabaee16e2"
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
