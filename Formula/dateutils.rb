class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.8/dateutils-0.4.8.tar.xz"
  sha256 "3f7054a24cf3e3ea2c32a6b1f7474334c25b54e9c45c96b03f75eaaecc70c100"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "c70b9979cd1f117820f6aa531731115772b6320e22ffb779cddc1e248387a139"
    sha256 big_sur:       "835ab3f87c6c6bf4a16b0e0f2e55fe16c4975ad63b1f8b7441786b9c75968c0f"
    sha256 catalina:      "27ef93f0c6c9ceb68087939e3c4d8e8511a15fe59b78e50aab0ecdd6365db976"
    sha256 mojave:        "e7649f49318c9f30cf4bc1c37bbf993b2a5471c7026bb4502000760c976d4892"
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
    assert_equal "2012-03-01-07", output
  end
end
