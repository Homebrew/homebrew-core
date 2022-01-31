class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.13/lcms2-2.13.tar.gz"
  sha256 "0c67a5cc144029cfa34647a52809ec399aae488db4258a6a66fba318474a070f"
  license "MIT"
  version_scheme 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(%r{href=.*lcms2[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bf1401db2c4733d9979b562ceef7441d32c4ceea61ae2f6eaa67434e39ebbe7d"
    sha256 cellar: :any,                 arm64_big_sur:  "c156e887110385516a29e5a118321f3c2449a6212173008a89943020f51d5eb2"
    sha256 cellar: :any,                 monterey:       "143b7de00312a4bf4684f01bed8daef204ed22a7932999ac9c33163ee7ce33a5"
    sha256 cellar: :any,                 big_sur:        "81d979f654532cc61edbf6492e49511edca3be33ea0903a368ee495ea29d6bb2"
    sha256 cellar: :any,                 catalina:       "642bde34490428c4afdcdb74c39b15648ff3170f38863f0ede93ace456a97f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fdce440186265d320501ead116aa22ab63118474b0f72564beeca6e587faae2"
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
