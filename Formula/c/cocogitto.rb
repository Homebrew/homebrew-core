class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.1.0.tar.gz"
  sha256 "756bc574f311311639723297f3dc793f7494d9b3ae375d6bc3e6e714432d08f0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "004df251f240684fe135ec9b030807c45588e8da945956211e1b89d45adaa548"
    sha256 cellar: :any,                 arm64_ventura:  "1e0817a7d4a18f09eebe6cbc25e96e6b775ee90bba6a4838d1a42176fad7f639"
    sha256 cellar: :any,                 arm64_monterey: "f335ea57fdb15cbe1ee1d48c12ddcd74bc17cb5e30775bfe9c1edb0e8a0ae5f2"
    sha256 cellar: :any,                 sonoma:         "4ab5b163ff85877650b2c75bf2ae3fd810e63581afff751176bbd596dc1e43e2"
    sha256 cellar: :any,                 ventura:        "9f78f20b0c8040290234517e747e8916be39f4b3c60052f84b2fb02f61c2d6f1"
    sha256 cellar: :any,                 monterey:       "390221017d0052519f5a2d86e503cbbfb42f3db79c8645602d3086da8555708e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5148acd4d1c14f5f3ffa6ab744cde6cdc663dcc8e700303fc6b15c44ba3157"
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
