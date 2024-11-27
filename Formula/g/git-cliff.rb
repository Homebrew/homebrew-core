class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "7b9a74f0871983bf5c326ffd7358ba46925f14a6feb1638c8c1e5d6b36448eae"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2fb29b8777798704eb1901a6785060ad5a47b092cffad50d6acc6ec062245fa0"
    sha256 cellar: :any,                 arm64_sonoma:  "43480bd28d408951e0a3d847b4f097768903ac106875952ce708d71b06272965"
    sha256 cellar: :any,                 arm64_ventura: "dc5184fddfcc1288086825c3ca7b794859daf5713868e54d688489dcf8f4a4ee"
    sha256 cellar: :any,                 sonoma:        "9b3b7c92b4486a5027dac55b19ddd60158d01d01da3d415d5bd207e2f407aa10"
    sha256 cellar: :any,                 ventura:       "08a1603984f16aec4cb47723bc43e02c77ca526aadeaf2c015b98e381b40408a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f98f9f194cda6900d532443f00966be066c4e47a004142b456c1dfd9900f4f0"
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
