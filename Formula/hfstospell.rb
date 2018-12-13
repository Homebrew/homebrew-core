class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.0/hfstospell-0.5.0.tar.gz"
  sha256 "0fd2ad367f8a694c60742deaee9fcf1225e4921dd75549ef0aceca671ddfe1cd"
  revision 3

  bottle do
    cellar :any
    sha256 "83198b2c45b82d445d6acd6ddac8de7c6e2fab365c3d6adb7a7d6cd7c9938851" => :mojave
    sha256 "69927247be97c86e0802dc26cbd5528ee1723c100aac2b4b864e2bf4abd0081e" => :high_sierra
    sha256 "2dab570b4bc6ae2569e344843b2e8010138ebbe6930e85944d8a9a3d956d1451" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"
  depends_on "libxml++"

  # Fix "error: no template named 'auto_ptr' in namespace 'std'"
  # Upstream PR 20 Jun 2018 "C++14 (C++1y) should be the highest supported standard."
  # See https://github.com/hfst/hfst-ospell/pull/41
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/674a62d/hfstospell/no-cxx17.diff"
    sha256 "0a3146e871ac0e3c71248b8671d09f6d8a8a69713b6f4857eab7bdb684709083"
  end

  needs :cxx11

  def install
    # icu4c 61.1 compatability
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
