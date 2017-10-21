class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.5.tar.gz"
  sha256 "2164592a67b467e5b20fdcdaf5bd4c50685199067391c6fcad4fa5521c9b4dd7"

  bottle do
    cellar :any
    sha256 "2c64ad6b69b8c0aa6787d001eb2f9abfcb4bd420ad3dc13e476ef2e02202a7c2" => :high_sierra
    sha256 "dcedf1b0e8d29c6edefcef515845828bf743cd6520498ddb648b3a1a3ecc6599" => :sierra
    sha256 "d36cd5e64d8c77c7658cc221fd5cef8cf110add87f0aebc5875c6c5059c48cc5" => :el_capitan
    sha256 "77b887abb2bf1249334aad8a26c6a66af562d923a23f742e042bcbcbf2dd1f38" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/opencore-amr/fdk-aac.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-example"
    system "make", "install"
  end

  test do
    system "#{bin}/aac-enc", test_fixtures("test.wav"), "test.aac"
    assert_predicate testpath/"test.aac", :exist?
  end
end
