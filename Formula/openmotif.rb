class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz"
  sha256 "859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7"

  bottle do
    sha256 "e90188438ef546f721a8818af80970ae9a7939b3d1a926d1805a266f4e4911e4" => :high_sierra
    sha256 "efdbcaaf32496ce3a728c75c2349e28ca8a4b53463b24f3907d55ede3a7a5988" => :sierra
    sha256 "73b9b20a5b215fa6f60facf5f431e29fd86110103f533adf6e340b4090c8ff7c" => :el_capitan
    sha256 "3184a926a49f650bf07e100454401a777233986ea2c69eb1fef0e2e7922ebcab" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on :x11

  conflicts_with "lesstif",
    :because => "Lesstif and Openmotif are complete replacements for each other"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match /no source file specified/, pipe_output("#{bin}/uil 2>&1")
  end
end
