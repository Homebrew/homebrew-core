class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.6.tar.gz"
  sha256 "aab61b42ac6b5953e94924c73c194f08a86172d63d39c5717f526ca016bed3ad"

  bottle do
    cellar :any
    sha256 "24dd7503944327a21fecc4b599364e4e75ac587d8e765ad533444161c27c29dd" => :mojave
    sha256 "d2ae46afcc4d6ac9357ab182950800d481d755eeac3dd8e53dcafa207cc6e27b" => :high_sierra
    sha256 "ba9e98f8efdc369531aba9de7d25e442c4c1392c3d4297e051ca3c58dcdb368f" => :sierra
    sha256 "f055e0e9755cf384a607738e2672ddfc2b63721f1ed271db5c16c7de1f868e01" => :el_capitan
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
