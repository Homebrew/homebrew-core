class Libsmf < Formula
  desc "C library for handling SMF ('*.mid') files"
  homepage "https://sourceforge.net/projects/libsmf/"
  url "https://downloads.sourceforge.net/project/libsmf/libsmf/1.3/libsmf-1.3.tar.gz"
  sha256 "d3549f15de94ac8905ad365639ac6a2689cb1b51fdfa02d77fa6640001b18099"
  revision 1

  bottle do
    sha256 cellar: :any,                 monterey:     "b295f7fa144af4cdd3b8e90f4519e2abe86bec8283ed809bffdabdbec934a0e6"
    sha256 cellar: :any,                 big_sur:      "02243fbcfb6de40f0c04b2341132e19c946be2b9fdf017f1838b3043aeddcedb"
    sha256 cellar: :any,                 catalina:     "fa858ef4b6b179d578663bbdb0d5c7490ea75a3921713e577a7f848faa99b601"
    sha256 cellar: :any,                 mojave:       "bbe040e330a998499e078129097a07f2c5de9fff9c5f26a638e6f5248badda3b"
    sha256 cellar: :any,                 high_sierra:  "7a4b394b51e89bd781fcce0514b3cc58656da63fa2e317186e47828e2c271320"
    sha256 cellar: :any,                 sierra:       "45aedd028eb76b2dfbb6fa3ba9b3fc809e7265411d5d7760997a71503ebae41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5670da1ec13772870636e0cfe96e851f021ebe997a3307725331cbea22062246"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
