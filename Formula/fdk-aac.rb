class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.0.tar.gz"
  sha256 "f7d6e60f978ff1db952f7d5c3e96751816f5aef238ecf1d876972697b85fd96c"

  bottle do
    cellar :any
    sha256 "94d7e94ce45859829961e826330356922fac58b5eb91c38f652b5717a32cf92c" => :catalina
    sha256 "f479a15b109a3cfacdc75ba6bb9564267761912f390cf3b92235f574fd4b69b1" => :mojave
    sha256 "8f0e553452bdf944e6c13fb653fc603d2b0ef5d6bd259627b02d3c31ecf99c1b" => :high_sierra
    sha256 "f398fc626dd0645aca5acb73974f7a93eec63a3957f1a0b16fd4de206ecd24e5" => :sierra
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
