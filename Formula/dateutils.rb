class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.7/dateutils-0.4.7.tar.xz"
  sha256 "49725457f5bef45ea424baade8999a6e54496e357f64280474ff7134a54f599a"
  license "BSD-3-Clause"

  bottle do
    sha256 "25d5db665c0591e56c4ec698656a5519f20417473e3cb763299d804bc735a9a5" => :catalina
    sha256 "3124ddab0439b64bcfc95057ee52c7c902e684898a2d96832732819682fba75c" => :mojave
    sha256 "310bbe8e2d4d039d065fb9bc5cd33ced2fc45f970057f21a205ff0004d6921e0" => :high_sierra
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
    assert_equal "2012-03-01-00", output
  end
end
