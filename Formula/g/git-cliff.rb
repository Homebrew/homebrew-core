class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "dfcf7b7d903c6479e58c8e7594364d67ce59e3e50351b3277eb33482a783418d"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c4137026e27290f1d3f572706918c143bd47e1b4a5d5c441ad06c6a2dbbb50c"
    sha256 cellar: :any,                 arm64_sonoma:  "b6dc4ea3cb260f82b1744e19249df7b5dbfb76957c11a054586f9ee1ed2310ca"
    sha256 cellar: :any,                 arm64_ventura: "f3c9e1c3c2024c8e82a9ade43eefe1acbf12a0844e1f1fa24b736e1d5101fc1d"
    sha256 cellar: :any,                 sonoma:        "79c25a7b60a18962e2aec34dff6d0da114cd3a791184eef803adf975187fc5c5"
    sha256 cellar: :any,                 ventura:       "86a3df0a100c044988c2c15bea9ee36718c1ead2dbd38fa75a001110565f1db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e92e3975360c506e30a55e3f56c7bfd7cd1e39472acf8469b844859eb02c8fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03773392efbf6465f066411f1cabed3f74523b755c4195b2ff90b9ff97003bcd"
  end

  depends_on "pkgconf" => :build
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
