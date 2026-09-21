class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "fbbb1f8ade8e9affeaacd632bedc94ac898fb726516f2f5a86d1bfba947635f4"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "69fe771ba746247b913c4ed681cfe1ccba1f5025ddbf22b49832436c0c48f7a3"
    sha256 cellar: :any, arm64_tahoe:       "87cb3ecf594fcb3d633860459dae6d4ab4951d1cdd2bd2978fdb58099f9022a5"
    sha256 cellar: :any, arm64_sequoia:     "f02241c6a9253453eaf643ce75f4af6b53f6f3fd7b3483a3643a5520108396d0"
    sha256 cellar: :any, arm64_linux:       "6baddeabcdac191f5f9f01e8f6c0330ad120be102dff6652ce76b5777af11338"
    sha256 cellar: :any, x86_64_linux:      "4e9cf54718d4d615e0ad2c4a47a2066aa5b8ed338a72518811279cf9f9a841bb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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

    assert_equal <<~MARKDOWN, shell_output("git cliff")
      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    MARKDOWN

    require "utils/linkage"
    library = formula_opt_lib("libgit2")/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"git-cliff", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
