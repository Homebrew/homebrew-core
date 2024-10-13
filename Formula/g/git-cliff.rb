class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "96d2759bb276bfddf4f6653a06afe2982d0bdc9678a5d2cb3880685a681a8a3e"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e38be5334e0b66baf08b69e292d52f27abc22aea4970dc14c1d3c2ededc8e841"
    sha256 cellar: :any,                 arm64_sonoma:  "cbb83919485ca184cb109f6f3aa27719251dfd9efc9b534c57132819055ccb64"
    sha256 cellar: :any,                 arm64_ventura: "a3dab23f71833ee3ed1a818fd8633242f59375690029f4f16c006a9af4f0f6df"
    sha256 cellar: :any,                 sonoma:        "13d20ac72e3f380d6aab5f4f0160be881b252b5f5501d79f047f7b2b66507a8f"
    sha256 cellar: :any,                 ventura:       "adc87f385c104c034cbb0914e81ba5b1fcf774d6f3d7e92998eaa57dea5a4c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d736d2e383cb6c3eb64091b40d8c71b2f9a510a6131767bf47c46efd413af7d"
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
