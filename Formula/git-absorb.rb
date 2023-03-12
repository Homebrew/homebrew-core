class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.9.tar.gz"
  sha256 "feaee35e6771d66d6d895a69d59d812cfbcabbecaa70ece64f87528a8c3c2fb5"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f678d1bc4450f8c028afedde10949fd35b44ac7bd591fb5b4e5d0b1239183fcf"
    sha256 cellar: :any,                 arm64_monterey: "6e03cfe030c55dcbf0511102585a15b35215c09cb7772126caf85a1b02163c15"
    sha256 cellar: :any,                 arm64_big_sur:  "80462448e675d5204cd6d689b6148a5cc9887a8cd906eb6fe303734e571aaaf9"
    sha256 cellar: :any,                 ventura:        "ce2e708695292d3b8e917e8a5dc0193d8477391f6ad1eb014858ea3554e00332"
    sha256 cellar: :any,                 monterey:       "58e08d227361fb9ba3673db8d24fc7ab938be1d23273522eb21bb123a733c2e0"
    sha256 cellar: :any,                 big_sur:        "8a78cb69ba8dd23088fcdb9cbe16482d0f6f79b35472945ae40d132b5a612d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4a50cb88696997435a845c23d5f4ece11fbaf4bcc7dbaa7de3bd8c6300a415"
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
