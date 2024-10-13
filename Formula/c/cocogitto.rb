class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.1.0.tar.gz"
  sha256 "756bc574f311311639723297f3dc793f7494d9b3ae375d6bc3e6e714432d08f0"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9af39545522af295f59ee4be503a0416a32fdd409253a55c927752e20b2fc5f4"
    sha256 cellar: :any,                 arm64_sonoma:   "78143145d4ad6e3882c09189bda0c96adfc34ddb544bee9fa5658c9c0a09d42f"
    sha256 cellar: :any,                 arm64_ventura:  "4d250f3ca8f2d8883c89f0ca7ede68c7f3bc36ddf113f17e19a69e4bb4430c72"
    sha256 cellar: :any,                 arm64_monterey: "8234e0b85119c68705cffda63d43f31b86c0336e0365ff2bdd47b6ea9d523393"
    sha256 cellar: :any,                 sonoma:         "2440a1f23340d2a4c190971535c346775f85c10d4ac1cee5b393c892002ed095"
    sha256 cellar: :any,                 ventura:        "56f49ee11cd3a9c2483fe81cb8bfbefeb17439dcbe246c5aee3e7da3ee1154e0"
    sha256 cellar: :any,                 monterey:       "84480d041c83ebad7f0ad1e4f7233505d8b083b81b716c2b83bf0ac9b9324694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aff6d16e56cddef28b7cad4d730bc0984c75134525f7e3761918b275774826c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  conflicts_with "cog", because: "both install `cog` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")

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
