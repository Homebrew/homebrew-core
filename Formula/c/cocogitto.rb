class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.2.0.tar.gz"
  sha256 "fd7d69fb5b6d64e292877d87a77864d5081906b6e515e20b93348b7f05bd05c1"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27fbf4df39907711ecc2c82abe07b3c689c876aae77aa5d325bcd9e9b007a7c8"
    sha256 cellar: :any,                 arm64_sonoma:  "63ca3e4a49d901c0081a84fadbcc1c5c987cadf9d625f083c04c4f55cf5efde8"
    sha256 cellar: :any,                 arm64_ventura: "95c4df0d2711c35731a3cd661220c2ad34f2fd286915b01910d70513088bdb07"
    sha256 cellar: :any,                 sonoma:        "79a4836653fa8d60418233598b0b9a3f26c9eb25aaf33031dd4015cb555cfab9"
    sha256 cellar: :any,                 ventura:       "bd5e839eb51f908c4986ac50cc7e437e3156ee3aec13b167f4c615a503fe8be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6c7bb4b0c937d23a8f7131d1df5fa8d129bb2fc98cd68ce5e987a3be79c841"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  conflicts_with "cog", because: "both install `cog` binaries"

  # support libgit2 1.8, upstream pr ref, https://github.com/cocogitto/cocogitto/pull/433
  patch do
    url "https://github.com/cocogitto/cocogitto/commit/47689fe4f431d7b1371ff34cb430fbffc19f40c5.patch?full_index=1"
    sha256 "508a34432f907500d2a92940647501512e789cac53e85497a83b1b99089ae07b"
  end
  # support libgit2 1.9, upstream pr ref, https://github.com/cocogitto/cocogitto/pull/439
  patch do
    url "https://github.com/cocogitto/cocogitto/commit/bf0933b33e1729161434b7cd92906c6e2d663016.patch?full_index=1"
    sha256 "5828494ce483901d1169acd714f7baf69a2c17eb1ecd716ea2490376763acef3"
  end

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

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
