class Jed < Formula
  desc "Powerful editor for programmers"
  homepage "https://www.jedsoft.org/jed/"
  url "https://www.jedsoft.org/releases/jed/jed-0.99-19.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/j/jed/jed_0.99.19.orig.tar.gz"
  sha256 "5eed5fede7a95f18b33b7b32cb71be9d509c6babc1483dd5c58b1a169f2bdf52"

  bottle do
    sha256 "941724406131fe66ca70a76684651b60e8aa3d1e80d3671c200bef831da5c1b1" => :mojave
    sha256 "c1e26f1498c5b47b04cde3bfaa7788acb72a52b54c50eb277368990ad2f27330" => :high_sierra
    sha256 "e99d46b4cea705e44633346466d725842b13ead13a1f9e2d08bfeb5f9edc41a7" => :sierra
    sha256 "a437b8f62da67b6c5177ee34df0a0f0906e94336454ec81f915cbbe90536cb07" => :el_capitan
    sha256 "3b316c792feabf9622a70a8ccdf2d2e985e7f991dbcd49a104b2ee6b8ea078cb" => :yosemite
    sha256 "f0e02951e534d96baad147970e51b2f5c09155ad0e51114cfc72b3f49301dff3" => :mavericks
    sha256 "595aff2e43b8ec8c31626831dcab83ffe4ffc129ea85efa61bc2e35877137a29" => :mountain_lion
  end

  head do
    url "git://git.jedsoft.org/git/jed.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "s-lang"

  def install
    if build.head?
      cd "autoconf" do
        system "make"
      end
    end
    system "./configure", "--prefix=#{prefix}",
                          "--with-slang=#{Formula["s-lang"].opt_prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sl").write "flush (\"Hello, world!\");"
    assert_equal "Hello, world!",
                 shell_output("#{bin}/jed -script test.sl").chomp
  end
end
