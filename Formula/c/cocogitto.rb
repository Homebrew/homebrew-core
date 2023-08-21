class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.5.0.tar.gz"
  sha256 "709c54c6c64463af607590ac970dc5a45cbcc0236a5a15d609d9a77461f11325"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "456942c9a48b07404d21a3defd62ebb9bde0a99ef74946f8873ff0aeadf5f90f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd0eb9639bcd1250e282a490f6ce81e75bec842749db1aba5f05085df3597645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "681033f9d26aa769f3860c43019a0be004df0f225ae6b5fa0a18bb4c6488ba50"
    sha256 cellar: :any_skip_relocation, ventura:        "f2abd54fbe1990daaac8de69ebc40e8d9169e49fe533c0e3796f8a6babfbdb28"
    sha256 cellar: :any_skip_relocation, monterey:       "a63c561c67150d972db228c8d2810c59727e252c4cc9a10949ee1c9c7952b8b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c186ccbddf859470d35777e3ec60effd384586769ee4d88efe05ca7e4d820853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d341bd7abf7da08a9b140f045a94d28cdd134809a57569b2122c27c5cd7265d"
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
