class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v2.12/mxml-2.12.tar.gz"
  sha256 "6bfb53baa1176e916855bd3b6d592fd5b962c3c259aacdb5670d90c57ce4034f"
  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a2b4ef33ab0e325d90dc981a1ec1dcc51cc7f655f9dbfdf4d1d22b77f2c485be" => :mojave
    sha256 "fb7036772610237c6f56e3ce22d3ca4d48cc6ee0b9274bedb5cc40468fa9e2ac" => :high_sierra
    sha256 "d4593b0721fa4cdec6664b30cf908fc70afa14cc904cf62cd6302c6435cc9c98" => :sierra
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
    (testpath/"test.c").write <<~EOS
      int testfunc(char *string)
      {
        return string ? string[0] : 0;
      }
    EOS
    assert_match /testfunc/, shell_output("#{bin}/mxmldoc test.c")
  end
end
