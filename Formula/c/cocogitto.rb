class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.2.0.tar.gz"
  sha256 "fd7d69fb5b6d64e292877d87a77864d5081906b6e515e20b93348b7f05bd05c1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1316b272cc20ceae0cea34737f3a2becc8a06d398b27dfce3b1015fd02ffebf"
    sha256 cellar: :any,                 arm64_sonoma:  "7ae176d0c770b599d2df65532d080c90e3d621509a6f2dae490aa8148a8f5327"
    sha256 cellar: :any,                 arm64_ventura: "792758a0e716a6a71775322246891153abb367de77e1591abfa98ec02a0d2190"
    sha256 cellar: :any,                 sonoma:        "726859cd13aef5b104f7093e2aab721ae1a6cde300d64064678728c3b0fbc15b"
    sha256 cellar: :any,                 ventura:       "5c85175e6d0a9071a4f3c746f09ae54a1932e70566a9279bdaa61d41bcf593c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84d0f037ed3ee459c1556a832e359b2970b4df2016c8ce888f5926dbebcd2664"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  conflicts_with "cog", because: "both install `cog` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions")

    system bin/"cog", "generate-manpages", buildpath
    man1.install Dir["*.1"]
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init", "--initial-branch=main"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip

    linkage_with_libgit2 = (bin/"cog").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.7"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
