class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "e298a7ff6c12ee26c814a4aad4829dc4078f1b767710acf0158ab40b0d0e9fe9"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "857c2529bb79fac2e45a26caad213b8b3e229943bc67e4178f990b78d1d4ea74"
    sha256 cellar: :any,                 arm64_sequoia: "9dd8d60870d3de54c08078ae2af8b01aa0f97084d0bfb4aba32894bb96bb86ae"
    sha256 cellar: :any,                 arm64_sonoma:  "984e836284f666d7e96bf1a2bdfb32c7c6c146967db79466152b18f7dd637eb2"
    sha256 cellar: :any,                 sonoma:        "a21ae3d285aa0082ae83d1321583fd6f99d6a66c642786ff8efe56e01a14ecff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ff5958694b142bd03258fb9660f51acc4b65eb02bb135e1f131180cc4ec847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca339fc01e512b632771d392aadce14e7e130d8663c062fd804608bd7a6d128"
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
