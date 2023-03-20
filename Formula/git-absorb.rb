class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.9.tar.gz"
  sha256 "feaee35e6771d66d6d895a69d59d812cfbcabbecaa70ece64f87528a8c3c2fb5"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "426726a6a169378925c36d190999306d8f5e9b644799b3fae2d8024996f75e7d"
    sha256 cellar: :any,                 arm64_monterey: "f9772277da668ac87e9de34b21b3e709cf43da95a97d55788f70cf9585ea59a6"
    sha256 cellar: :any,                 arm64_big_sur:  "4e9b27087a3f4ef04b08d68e7412ae69e833e42ad6296c22fd67accbdb87fe40"
    sha256 cellar: :any,                 ventura:        "d2b1b51f096629140558b6e146b35910859843b03585dd55f5e58ab83bc04b94"
    sha256 cellar: :any,                 monterey:       "e73ac5e72d5a173d667c1d009a0f335c615ca30b998cef1a44473fab4c950363"
    sha256 cellar: :any,                 big_sur:        "42b2cb619d9b9705e4d43a895dd41b84876779fa106f153714ffab7519a41b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c233480b6a03846682a55bfbe0da325e574e70ffba9d1bb5a5f8d58638532a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
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
