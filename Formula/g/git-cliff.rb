class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "d5791600e440d0842e42f3b0dbc8d503f4902920675054a23f046fbb1c252636"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1bad06f26baac7f0221892aca5b1acc0900ba7d302d16a758de42588079b9c05"
    sha256 cellar: :any,                 arm64_ventura:  "fe46ef9c25cb57e4ab01e62bc2327eb19fe4b2768f4e966c885a4f158654fdc2"
    sha256 cellar: :any,                 arm64_monterey: "3ab5b74d79888c5d344e3d317a2ce572b31eb20b6292b61acf1eed3128ce7166"
    sha256 cellar: :any,                 sonoma:         "799e11a01fe28b60f87db38473c1b3ec9cce267ffe466683c76a8e4a9608cb65"
    sha256 cellar: :any,                 ventura:        "00ad01967b2e0b0883e425d5a2f636cfa61b07c6ec6046169c75a8057b0c8228"
    sha256 cellar: :any,                 monterey:       "24de5cefc74db91f258bfeb05d5308dd44c8f9f813e017dbfe229e4b8a82eb78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e11c07cd67b47a9886b0d8e176132f4af00c824935ca044e47fdb64a27352d2"
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
