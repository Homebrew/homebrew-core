class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "909b652939299040ebbd15994d710aff7e38fa38683bb5111dd46cc4ed454b43"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d105241e4938241dadf3339827303bff621f9b148975e2668f4b0a865b1cf3f5"
    sha256 cellar: :any,                 arm64_ventura:  "265420c86b0cb0818ea00b0112f78ce85936a1215c0e86eb0d28b8b892cc83d9"
    sha256 cellar: :any,                 arm64_monterey: "611c085855ca2bc9ee77539ce104f6b538269b2175f99bfb1f1479d1e6253c25"
    sha256 cellar: :any,                 sonoma:         "d4ef877b14ba2b3a3b6ced90407a3c4ff2794dc0ce0abadc5e4d761b1e8864b8"
    sha256 cellar: :any,                 ventura:        "d4a5553e5fd5df120570fc02cb51eccbd8e61e11f780f3ca27b71bfb17662321"
    sha256 cellar: :any,                 monterey:       "e74d9a12e07e2f6a8f3a982f3aad52f30261bdd581344e1e0180509fe448ea21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "729942b1b50484dc32740d06bec62299db54fc4b209d9446b90643ba208e0b7a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")

    linkage_with_libgit2 = (bin/"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
