class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.1.6.tar.gz"
  sha256 "5b706e1b362c1f05093e1436b396fc8129c6e456a112b9e4a06fd7916f19baaf"
  license "0BSD"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ca1368008dd3f33de145cd35fecbb797c76e872d303348a98a35d56a6a6d03d4"
    sha256 cellar: :any, arm64_tahoe:       "bf96150ee06afc38b6fad05ea0024ec7dc91d95478188f02d999c282a428c24d"
    sha256 cellar: :any, arm64_sequoia:     "97f0555761cec8169d62cafea7cb9c5e603b94af332ce1e2e21a6a529c033174"
    sha256 cellar: :any, arm64_linux:       "0acc450fdfbdf909a71ec6428f286a480ca6c6e34fdf434be811599cb8b739f8"
    sha256 cellar: :any, x86_64_linux:      "ab8db692a5ee56c96932653e916c2cb3328d0e2768f726fb32310f8babb61729"
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

  deny_network_access!

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
