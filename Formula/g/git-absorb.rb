class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.6.16.tar.gz"
  sha256 "d0fac448801674a4d4d5d42d6ef2d2e21545ad66755023c531a273a47893a573"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "642563694d9d397f39c68368965fa1f80b0e76840ce400f4f92c7e3b07dfe7e2"
    sha256 cellar: :any,                 arm64_sonoma:  "717cf20e7c9341f2d20b0b17d6e188b6e1c3e2795409df79642cf6efd6bd7811"
    sha256 cellar: :any,                 arm64_ventura: "47e0e651f3848fb5b07fff7d43853725b573aa69d98c9ec03fb78492f58098d0"
    sha256 cellar: :any,                 sonoma:        "09fe5516b5b7a42fd378a7b63ecbbbc945b03f4ee6a183e175c689b4b6c95034"
    sha256 cellar: :any,                 ventura:       "cf1478d96f79469824668a92b25b6d40d47fc8abc14a8ac2df4891db8701cc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca35199361f91362a640963a2b19fd16b741613b22552d142690055fadb7e70c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
    man1.install "Documentation/git-absorb.1"

    generate_completions_from_executable(bin/"git-absorb", "--gen-completions")
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "absorb"

    linkage_with_libgit2 = (bin/"git-absorb").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
