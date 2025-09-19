class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "5983409377bb34337ee930af53afb522737d87b9ba15096eae30ced3484b12a2"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bff334271080c4dd3019fc229921aa8df21c27b3e74b092e1da4185e87f106a9"
    sha256 cellar: :any,                 arm64_sequoia: "3cb0c87376ca2b155770ab7ef8e9d2aa2b9376549e64f1021a5c4880108750a9"
    sha256 cellar: :any,                 arm64_sonoma:  "befc35faab195db834be9399457f6b11d53048d64b562a2507125cf14811a292"
    sha256 cellar: :any,                 arm64_ventura: "68a9bc5425561ff4cfb0c23cc24e58cfd7373e4f5ca96deb94d66d97a060d25d"
    sha256 cellar: :any,                 sonoma:        "bbcd18d3b420655522ab5272039530bdccc9a8355b4d67f858d7eb52ad584dd4"
    sha256 cellar: :any,                 ventura:       "f47c539d319736549a62b63d6716b511fa5a9b17c58d05bdc0b50d2ac7bb8c20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0807e2f92262c4eb5a38e4e3082fee1bcc08a7e0432b529a6e55cca9b0b8f546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733633afb16d7266616a675734dd21b96f7f4f131f583ff036a648e6d437b45e"
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

    linkage_with_libgit2 = (bin/"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
