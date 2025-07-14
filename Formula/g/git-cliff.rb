class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "dd5a707fba4549ab4ea5e9e95ea7ed302852eb1916b93a1a369019f005ad4cc4"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "825cba9fde4d404bf9d7d6a0cf2be44e798b73eba18c9cde0a4a836b303642d8"
    sha256 cellar: :any,                 arm64_sonoma:  "d518498eefaba737ec87a7f8795d1d36be7e59cea589dde5e75e6c80f4a063c5"
    sha256 cellar: :any,                 arm64_ventura: "1b2c7e461523689e742421a75eb0b9f9925eec9514bbee9777fb98f6de027de3"
    sha256 cellar: :any,                 sonoma:        "dc9dbb0924f75f4061546fd549d0161d33f49b7dad3d78c615c9a6516219ef2f"
    sha256 cellar: :any,                 ventura:       "4a6aad6de7adde64aae0b0f7706e973f50d06364d1fa8eacb00dfecf14659ca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba502e2c1481bed061284320831447bf5690cb4a1547c2ff1f65f51451cb1e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38c9b94e7efb7e59903201e8d15e5758bb488f4be9a4e0cc20627561123bb1b"
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
