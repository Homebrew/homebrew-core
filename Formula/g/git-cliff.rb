class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "ab29fbda532bec2a344d99f39b7998063c576efee92a1bee083c6fba5f52e4ef"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f94f82704e925bc81e0dbfd23e35817bc6ee246c2ae2e66fc4855f756951367"
    sha256 cellar: :any,                 arm64_ventura:  "d9b53988f947087e73b870bf36a748047f688ddc19cfa83ca282b73a5300d8fb"
    sha256 cellar: :any,                 arm64_monterey: "3c0663977e411136e2873708ce3a0d8c29536299dde578f441e2588ef048f786"
    sha256 cellar: :any,                 sonoma:         "bbf63149a78b25652d0d52eaa387249c433698b7fab8b2cdd22edcc7b05f1195"
    sha256 cellar: :any,                 ventura:        "490f5d6bc63870535c0bd638613ab0b6847053fd2872054fda0be96fb005b0fc"
    sha256 cellar: :any,                 monterey:       "4e29c6c850b0cd584fdade92b3b1f6c494c2f9c47c44f7eca55f67714160c345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89fa2b57b489affe2d6620f6652e86868f84f3fa18b530c5d0b0deb6777fbcf7"
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
