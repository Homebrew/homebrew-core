class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.1.4.tar.gz"
  sha256 "0cac6849efb8a9447268fb273de3fab38f8460adb26a1770934e3f325fab8f5d"
  license "0BSD"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "28046c8bba51b65c2d7697ff06960470dd3319bd10feb1b844bda95aaa73c15d"
    sha256 cellar: :any, arm64_sequoia: "6ad4f55e8af45014f38bef001286fe9235e4cdb22842d6b8acc0c4031f2c98fe"
    sha256 cellar: :any, arm64_sonoma:  "77033feadcdd2026a9248ed47fc9178771b410d879148380d6e7481fc6ce3506"
    sha256 cellar: :any, sonoma:        "5eedd8fc518769e48054a5045996d66094b404a90192c8c30b2cb31a13878c55"
    sha256 cellar: :any, arm64_linux:   "cba8e01b15629a1ac2d85f5ef9a684eb0235db4c8e3ce02718a800132a565b8f"
    sha256 cellar: :any, x86_64_linux:  "3fde513eca75277a3cd613614254f67314303c4b438fc2b8c41044e6d159556d"
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

  fails_with :clang do
    build 1300
  end

  def install
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
