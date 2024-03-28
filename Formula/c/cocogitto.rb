class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.1.0.tar.gz"
  sha256 "756bc574f311311639723297f3dc793f7494d9b3ae375d6bc3e6e714432d08f0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2fb27f968de5a96b8e5b4de66278bdb28175e3a11c9c7ffefb310eb5f754dd42"
    sha256 cellar: :any,                 arm64_ventura:  "52c7d9885bb7821020bbfb9ffc5c83785d22557976b097f9b8bfd0a0d91f5a91"
    sha256 cellar: :any,                 arm64_monterey: "e35e23608097b2c0b19ddd80d92d822d0946fdd57e3efd4d92c68061b4ddfc82"
    sha256 cellar: :any,                 sonoma:         "bf59ed82a50b8736688c08920e62995a64fcd9458618ac99a744000e0db2c5d7"
    sha256 cellar: :any,                 ventura:        "82b883bded084a14fde4f9c43cbe6899fda964dd0cb93ff6d3796128fef6607d"
    sha256 cellar: :any,                 monterey:       "7d9b6127b3be372be6997f7f73f05f3397c534c268963ec60807c5c463c646d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85e005c9916cb296e24e246c4531ebf22b0a865f4349c904338bf39ae8bad14"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
