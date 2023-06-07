class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "10db6fd8fe777f384de2e00336b1cb664095a2f068526f8ace4e7944a7ada270"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "67e97f4a1b6da20215be6400dcf1b93c107a044c848fc1545d8ee8033f4d7c0a"
    sha256 cellar: :any,                 arm64_monterey: "d91841d5a53dca96decb13f9e1471a1b09760f193cfcd6171841b7a8118c0d3b"
    sha256 cellar: :any,                 arm64_big_sur:  "2873a85f1fc86aee18de54885e25254be210a9d53c4de3846c427da2cce1fce8"
    sha256 cellar: :any,                 ventura:        "3fae07e67f5360602f67b04e5577a7cf429bf53c84de67599d910417f2f62874"
    sha256 cellar: :any,                 monterey:       "ef43f2262656247517e3c3e0ec372205c4f02b5c3664200c2a77c202852a9e74"
    sha256 cellar: :any,                 big_sur:        "14e2fcd17a28ffb622329ccb31bb7af84ac0b85da93c37a6dee9c32aad9bcb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82d81f3e300727fc927c63bbfd7552569e0ea0e84ff971c575fe0d93c262ecd9"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
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
