class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "3f281063fc6554a681dfa6c67afee8a1ba541cc8b8082dd2e980b1b6251a1c6d"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d9e81ac5b011a56548766465bc31bae07f4cf47f8de008d1708cf0adea224587"
    sha256 cellar: :any,                 arm64_ventura:  "6381792704010306a949a78c9a1155f5a27f63d5d482a3165620e0649987a3a4"
    sha256 cellar: :any,                 arm64_monterey: "9899fc654a02cf2a0099ce021b8871e601afc2471b141ac647908335ff99d3dc"
    sha256 cellar: :any,                 sonoma:         "16582c67f65da303ec053690912f688329a18b99481e68e7c3adf12492cb255a"
    sha256 cellar: :any,                 ventura:        "03331bc4fd8ed076d5681b8706dba7a0fc71d9c75d60255411cdd8a74532dbcf"
    sha256 cellar: :any,                 monterey:       "e3c8ceea4fbb83f7028c6729a0b1d7272fc840c68c31881668efcb4c933682af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a88b5998e8cc9c95e2c0a04391c90df890c2fce239c95ea13e0d031b6a2973f"
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
