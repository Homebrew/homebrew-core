class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "a234fa1b78f7d9807ef1e41e6c36e56f178e65aa0f6e1fb7100cf144def2f180"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0671857570d54832691f72961ed13e4a7ba7427a62173a1900a03f5185c00ca2"
    sha256 cellar: :any,                 arm64_ventura:  "11d4d46ef6112ff352dba65cbd16682f33d8ce935530f1778c106f20c6813d61"
    sha256 cellar: :any,                 arm64_monterey: "c6a4548c6f9de17f28d00cd49edaced9578d7850632e058ef240930068a2dfbc"
    sha256 cellar: :any,                 sonoma:         "504ddfe5b54dd637a6db093816c8a79b01aaa97945ed295ea9ebcdb46d7ac8ae"
    sha256 cellar: :any,                 ventura:        "a741b3bba2777733488207a929bed589779051dd773a84730d9fb85ec7920190"
    sha256 cellar: :any,                 monterey:       "eeef9104cdc38294a62ce38f8a02b2848f23869fd3ad3ebf0231f073a2205bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b92548599ce8164a49641809cc092682db0380880d5226b109f95c97e97e2538"
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
