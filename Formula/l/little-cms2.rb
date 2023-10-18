class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.15/lcms2-2.15.tar.gz"
  sha256 "b20cbcbd0f503433be2a4e81462106fa61050a35074dc24a4e356792d971ab39"
  license "MIT"
  version_scheme 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(/Little\s*CMS\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6423981030e9951b0daa62678e90d1bfcd723d13bea30cada62844b5b1d5a4cc"
    sha256 cellar: :any,                 arm64_ventura:  "ec43c4b1d15b75200740331b92656b624be01bd40cb993f862f41aca60ae670a"
    sha256 cellar: :any,                 arm64_monterey: "de857ee35cde49fb0c675a9620796d9ee8f3d71a995351c8ff7a86ed23bda8e1"
    sha256 cellar: :any,                 arm64_big_sur:  "64597b6b3dc07b07e06aab5280eea44493166bfcf21800cc8d16b3353ce7a37d"
    sha256 cellar: :any,                 sonoma:         "d6e6462049c343d51bfd477be36c9f31414db64f44a0205f7cc7f555b9de8dbc"
    sha256 cellar: :any,                 ventura:        "c0bcd5e7befef41984d5d55ee139c807e47cb43837d39a9bf4598b251e552371"
    sha256 cellar: :any,                 monterey:       "4476622668a4a2290fe41470f656ff8d2c4f5b55122419020d99e0b54d847103"
    sha256 cellar: :any,                 big_sur:        "c7cb39e28b14011c8ccf73c5de99c77328b6e41626bdfa400265e83911dd2070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1b4f53e85030cd1f5e52c997cbea72e77f68472f8bff18a8c18f0d08f751b1d"
  end

  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
