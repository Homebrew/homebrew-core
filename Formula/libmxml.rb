class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v2.11/mxml-2.11.tar.gz"
  sha256 "aaf68aac637dd06ba73ae5bb0537a3c4e89ca86f8c09a2d806a1f5b937e2ba8f"

  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    cellar :any
    sha256 "ce2ace2a91e3d948911a6c44c378b092d8dc807aff0a328a705822ca5c391b41" => :high_sierra
    sha256 "4287dd3c4346f82d9a410bf4bdce69329ef1f931e7639e6c27fa8f79e1e31cb4" => :sierra
    sha256 "01d01bf5766e398837a416949f74eb405e57903dbc27a55fc589e0559e60c518" => :el_capitan
    sha256 "bb2a6d25c76e7e65eb5a14728763a03f41cb7c5f68bb43cd73da4f92df0226cc" => :yosemite
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
