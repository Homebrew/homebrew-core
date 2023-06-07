class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "https://libwpd.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpd-0.10.3.tar.xz"
  sha256 "2465b0b662fdc5d4e3bebcdc9a79027713fb629ca2bff04a3c9251fdec42dd09"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libwpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99f0b0dd570023f92e2d932d5a6fc9308450fcc2a89a5af43ce595b477bf90ba"
    sha256 cellar: :any,                 arm64_monterey: "07859be4298f02006c4fc96a58d0cb26a01302d8417ae4131d40342bbbb069a3"
    sha256 cellar: :any,                 arm64_big_sur:  "0a31f499bc64b2f40d0eca1eb0b4c1e0be8b54f143692aa498d2e3003e5afc2d"
    sha256 cellar: :any,                 ventura:        "94ab87267b633ee7c374462f66cd7a377253c302d651228a2ae3aadbf45e5ef2"
    sha256 cellar: :any,                 monterey:       "21ddf2818ce34d1ece8233dc5b48d8ea26f1f626faee4ac0745cb5a2fd2a8277"
    sha256 cellar: :any,                 big_sur:        "dc99c9e01014aefc2435c222f571dbd7e36cc7ba4b275b0ba826874ed6b1c416"
    sha256 cellar: :any,                 catalina:       "edb924ac33633d851f162839c2e1ef57734c81bd5a6d3d2cde7750175bd19386"
    sha256 cellar: :any,                 mojave:         "b9cdcbf1e0c875c8666f16a9547386754c40607652b0255d6eda8b2afb2da229"
    sha256 cellar: :any,                 high_sierra:    "baba04ac2fc8bcd2bbf890f8d7e3e27f7eae3044d960f027634e3d0310447dc8"
    sha256 cellar: :any,                 sierra:         "f4ef8b16411ea32e77e35bf0a8109b5f7651931e885ffd4ad7a8933a12d4f749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "589effab1c398690ba5ee3b616d3ab9667260d013ac3ebb93aef4a69dc1ebe9b"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "librevenge"

  # Apply https://sourceforge.net/p/libwpd/code/ci/333c8a26f231bea26ec3d56245315041bbf5577f
  # Remove with next release.
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["librevenge"].opt_include}/librevenge-0.0",
                   "-I#{include}/libwpd-0.10",
                   "-L#{Formula["librevenge"].opt_lib}",
                   "-L#{lib}",
                   "-lwpd-0.10", "-lrevenge-0.0",
                   "-o", "test"
    system "./test"
  end
end

__END__
--- a/src/lib/WPXTable.h
+++ b/src/lib/WPXTable.h
@@ -53,7 +53,7 @@
 	~WPXTable();
 	void insertRow();
 	void insertCell(unsigned char colSpan, unsigned char rowSpan, unsigned char borderBits);
-	const WPXTableCell  *getCell(size_t i, size_t j)
+	const WPXTableCell  *getCell(std::size_t i, std::size_t j)
 	{
 		return &(m_tableRows[i])[j];
 	}
