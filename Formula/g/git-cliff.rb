class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "2a55fd44467dfb6b0a0a494328af2b664775f938367603e1f0441f66c7146732"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8ff71f07e4ca5d7e5c1a1d0e40272a261be049d7e433872c1ebb03d281cf4f2"
    sha256 cellar: :any,                 arm64_sequoia: "a4b743b1bb268c652d6d449828ab3fa58100164a4de8983a80ab15d5a497cc6f"
    sha256 cellar: :any,                 arm64_sonoma:  "117a0e83dac2503c680e2d94ccf54b329a302b9bbc7c3182a25a0fd5c12d0df0"
    sha256 cellar: :any,                 sonoma:        "191f40af9fe03bbfd35c4309f994821a0fe51e3698dae4f9a21ef1074aabbe5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "016b1f59ad4750b2623bf567d5affe869de4da94f6bc8ab2d9ac1f1119081cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4f4d9d3c654f43227a90669f4ae00114b8b06ef49e076a6af17a9f6ab65aa09"
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

    assert_equal <<~EOS, shell_output("git cliff")
      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    EOS

    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"git-cliff", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
