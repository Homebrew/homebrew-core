class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  revision 2

  bottle do
    rebuild 2
    sha256 "71d93bb50f6efde14a06a424cfb6e1aa23d807d670c38b8fa8c2230019d965d4" => :mojave
    sha256 "d553514bfafe12ba7a964c4ebeab97d52b389ec1b6746b594802893d3fa088ae" => :high_sierra
    sha256 "52a68836064a6f3ca484e212f4a160cfd16329767fe56cb924a8360441408485" => :sierra
    sha256 "b59da2e745cd4882f3e4e848bb4473ec97f110eb06df9c9fe442a7c39cf6e141" => :el_capitan
    sha256 "d6412d12d0adabd9da112e49baecf351b0a0307d138d22c605fa3826107107fe" => :yosemite
    sha256 "3bb5385dd074a8963bb3fc9111ea6a318d2594380cc8eda4921cb4a910393578" => :mavericks
  end

  head do
    url "http://elinks.cz/elinks.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    ENV.delete("LD")
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey",
                          "--enable-256-colors"
    system "make", "install"
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <title>elinks test</title>
      Hello world!
      <ol><li>one</li><li>two</li></ol>
    EOS
    assert_match /^\s*Hello world!\n+ *1. one\n *2. two\s*$/,
                 shell_output("#{bin}/elinks test.html")
  end
end
