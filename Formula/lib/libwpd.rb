class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "https://libwpd.sourceforge.net/"
  url "https://dev-www.libreoffice.org/src/libwpd-0.10.3.tar.xz"
  sha256 "2465b0b662fdc5d4e3bebcdc9a79027713fb629ca2bff04a3c9251fdec42dd09"
  license any_of: ["MPL-2.0", "LGPL-2.1-or-later"]

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libwpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1bf99b7a478fd8c861781c680257297389a1d6e1cd43930e0e6ae40a3caaac23"
    sha256 cellar: :any,                 arm64_sequoia:  "71e3f65d29d9aa0f23401a25f63b8abf5168d88a6406664c13588fb73261b897"
    sha256 cellar: :any,                 arm64_sonoma:   "b6800d44d6079dcbd79adb7942599eda78fa890d16ba5b7eeb2c4efdd1791ca4"
    sha256 cellar: :any,                 arm64_ventura:  "99f0b0dd570023f92e2d932d5a6fc9308450fcc2a89a5af43ce595b477bf90ba"
    sha256 cellar: :any,                 arm64_monterey: "07859be4298f02006c4fc96a58d0cb26a01302d8417ae4131d40342bbbb069a3"
    sha256 cellar: :any,                 arm64_big_sur:  "0a31f499bc64b2f40d0eca1eb0b4c1e0be8b54f143692aa498d2e3003e5afc2d"
    sha256 cellar: :any,                 sonoma:         "2b25a9f4f6a55fcc60a533eb12531a394761f19d5701e8ba5512f654c04d2c11"
    sha256 cellar: :any,                 ventura:        "94ab87267b633ee7c374462f66cd7a377253c302d651228a2ae3aadbf45e5ef2"
    sha256 cellar: :any,                 monterey:       "21ddf2818ce34d1ece8233dc5b48d8ea26f1f626faee4ac0745cb5a2fd2a8277"
    sha256 cellar: :any,                 big_sur:        "dc99c9e01014aefc2435c222f571dbd7e36cc7ba4b275b0ba826874ed6b1c416"
    sha256 cellar: :any,                 catalina:       "edb924ac33633d851f162839c2e1ef57734c81bd5a6d3d2cde7750175bd19386"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "81464149ac1791ff235b62e286bff669440c36793e92b039b648b96c42d9e73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "589effab1c398690ba5ee3b616d3ab9667260d013ac3ebb93aef4a69dc1ebe9b"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "librevenge"

  # Apply https://sourceforge.net/p/libwpd/code/ci/333c8a26f231bea26ec3d56245315041bbf5577f
  # Remove with next release.
  patch :DATA

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    CPP
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
