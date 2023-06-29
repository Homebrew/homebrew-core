class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.4.0.tar.gz"
  sha256 "93065217191d3e1739e6bca78b0b6de7d7dd1b5334229702fff9e84162060feb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d0f4ff56482a662d285b666d9030c20488466fdf27383ef8a46285c2a0b460e3"
    sha256 cellar: :any,                 arm64_monterey: "ce1322bd55e47a79ce7d44f788c4d30f7998a3da705736ed8e0a3053023663fe"
    sha256 cellar: :any,                 arm64_big_sur:  "3dc3218633779197ee83d3a5b5533b8f4865eef5c9ab2d664d26dfb7b4165171"
    sha256 cellar: :any,                 ventura:        "dc004e3f1d7b8ac3c4483ac4ae265c357943383185af674b34879a33c4a4131f"
    sha256 cellar: :any,                 monterey:       "6c63e7ef30899de9a20e12957ba90dcb32ac485a5711f4e4efb8ce3b6733d934"
    sha256 cellar: :any,                 big_sur:        "a7aadf2c28eac11ba755aedf12df88c0364d865f0edbbfe7743cb8bcf3e4a615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d09607c9674b3f3c8d80edf83eb4bbc2e315278e36f0fd9ddbcc044f7abd55"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip

    linkage_with_libgit2 = (bin/"cog").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
