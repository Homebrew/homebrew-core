class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v2.12/mxml-2.12.tar.gz"
  sha256 "afd6b75a120dc422c7b45dca19254f535d51c37b73f6783962b1e14b54c716fd"
  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    cellar :any
    sha256 "a5e58b0137687c3fb938f38bfc57573576ad8840b120d5befb4bf707e8a5b1e2" => :mojave
    sha256 "51c6ef931e9ce4d8b477826223ac3afb961b4522903a710ced751d82081a67e7" => :high_sierra
    sha256 "fb13cdf0e19d628feffbddc62e3e68306eddc31334414d02eddfade55069fe28" => :sierra
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
