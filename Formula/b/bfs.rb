class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.1.7.tar.gz"
  sha256 "7b17e3ff2fac9a41ca9f06f61cfa1c7bd2474ad583fcbbee6e6d72fa8572c837"
  license "0BSD"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "365160b2d4d45d2dcdce00877fc6d564a56a2ec3257eee574dcd0f9531e958ff"
    sha256 cellar: :any, arm64_tahoe:       "809628e23c215f9eeff039b46deb44396308443129cc25821be473ac19bb4b5f"
    sha256 cellar: :any, arm64_sequoia:     "2d65189b04f927877b28c277dd7f94d6c6b71d80d2243de3c43d797f47e21437"
    sha256 cellar: :any, arm64_linux:       "96aa01370729c3556207bcddce80ab55a3a0cc60e20bb81755f0ce79e68fbc75"
    sha256 cellar: :any, x86_64_linux:      "ec3dc2f1eb5d31dd3e546796c120d7ca804750bfee8b25779a671e05367be0fe"
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
