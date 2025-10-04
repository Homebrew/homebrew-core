class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.1.tar.gz"
  sha256 "7a2ccafc87803b6c42009019e0786cb1307f492c2d61d2fcb0be5dcfdd0049da"
  license "0BSD"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2d197823d3ea09db80ff41a0a887b3278c9b1f28db50c683f17f8233a26e95c9"
    sha256 cellar: :any,                 arm64_sequoia: "cc95849810fe6c692160249cc81d38f1a2cd3e0f5d6f033e0bd9342429116e40"
    sha256 cellar: :any,                 arm64_sonoma:  "dd75c7c57aa181eb29832ee8c1fb6d4530f8509672d9bfb27e19134309507d2d"
    sha256 cellar: :any,                 arm64_ventura: "5b0fccf7829272c6a2c9d10c7432b70c912fbb5174eeff38a64ddbbb165bdce2"
    sha256 cellar: :any,                 sonoma:        "4c121ba08ed118750411c1003e9e078420e98a819258816f133b6ca0c83f2473"
    sha256 cellar: :any,                 ventura:       "50c78795197923422f8f51d5099dd604027a289701f9af875e7f942e6443e9be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3a3ee53d9833b58291c0e426afbdd4bac5a880c9bc77585d42e0205fb00785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "724d215224af855240f52ca8f0ad7fccc8c1d2dace5f770692f699a8dd91c09f"
  end

  depends_on "pkgconf" => :build
  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system "./configure", "--enable-release"
    system "make"
    system "make", "install", "DEST_PREFIX=#{prefix}", "DEST_MANDIR=#{man}"
    bash_completion.install share/"bash-completion/completions/bfs"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -regextype emacs -depth 1").chomp
  end
end
