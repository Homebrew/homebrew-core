class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/release-2.10/mxml-2.10.tar.gz"
  sha256 "267ff58b64ddc767170d71dab0c729c06f45e1df9a9b6f75180b564f09767891"

  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    cellar :any
    sha256 "09996d5f7f65b41706c42092a5a55e81b387a30f932741ebc3cab7afe27d72f3" => :sierra
    sha256 "9cb1dd58ac3f4e3ec51a78bce4ca142eafb12cfc6a890fd3eef7f4613ef70aba" => :el_capitan
    sha256 "804da1287c900a1938f8360bf5df961fa85de040ea85fd0ad6490b7f30373af1" => :yosemite
    sha256 "d92c245dcf1edb8c4d218f7506748cced58a5c5a7b7cefb9632ef22958ae7abc" => :mavericks
    sha256 "df203c2e058d9e4d7980c1bfef686a2033f3ad84e3b405ef2d698dbffbdc3919" => :mountain_lion
  end

  depends_on :xcode => :build # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int testfunc(char *string)
      {
        return string ? string[0] : 0;
      }
    EOS
    assert_match /testfunc/, shell_output("#{bin}/mxmldoc test.c")
  end
end
