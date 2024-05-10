class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "8573c4dc28fd6d6c1e9be7156193c13d177af093a060ae9e3bd4cd60ff3e05c4"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a167776f5ccc36bae83ad0af38f248016f4a8bafd251e95e40c5dcb53fc05d6"
    sha256 cellar: :any,                 arm64_ventura:  "c1d0f4bdb2c8325a89a6ec7c6ead01da68f1deb9fbeb65efb57ab81c7d81a9be"
    sha256 cellar: :any,                 arm64_monterey: "a21010cb27c62069e20b7f4411ac02cf757b4764db9c9d2e102a163681d267b2"
    sha256 cellar: :any,                 sonoma:         "9420f7cda3825cf4fb9adbb5f7b126e6424cb812255106c3ad0443dbf3f5ef9a"
    sha256 cellar: :any,                 ventura:        "4dfcbe6b74f2a970c5efd21a627338d31fa323dabf4c33730829bafeb4512ba6"
    sha256 cellar: :any,                 monterey:       "b5a1415db305155a4213cb5f41a22d08d3f6dcc73102b2757268923e77215e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e675977d7383c4faf364a0b8b31beaec3c1324489bb49b088ab76888af5d02"
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
