class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "172888704ad429e238e61472e31704d4fdf5ff9c2c04479bb9452fb70d7a9278"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a978b84549832e62979abce0b5377b3a64b2441e2ccae3facfea04133257c02"
    sha256 cellar: :any,                 arm64_sequoia: "27fed8903d353b11137224ecee446ad9079cbc961b5af6985cd3dc3aa8f8d5cc"
    sha256 cellar: :any,                 arm64_sonoma:  "f1f0402edae6f7dd97b0e4cc52e2c0cef8faaf6580a7264d45550017ed5ebc47"
    sha256 cellar: :any,                 sonoma:        "456cd8d3c1b270b0212d5c8135d0166fa5659a6487865a3263b027a40b7d26c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "047289bef8f7f6eb7f7758abdbc637734a13f4ab3e804a6f87f24cadcd924343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cffef67f47048fced6244c5c51525ada1b3a3634b7d40c082effccbb0dbf92d8"
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
