class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage "https://flactag.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz"
  sha256 "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2"
  revision 1

  bottle do
    cellar :any
    sha256 "d066a517308ad0f3cbc6603fd7eeb53dba73dc796298163b6c1ec8c0379f72f6" => :high_sierra
    sha256 "c23293dce964c701fbaa822bda3a5f87602b28216b3862afced4da53c12728f3" => :sierra
    sha256 "d3e7a517f69ba267c5ff36c065837a4c2925a31d2b0cfe6f5cb32d8d0582fd8a" => :el_capitan
    sha256 "f5f0123f156ccf4c40e810fc5f0acc83638e35da13ed900b2f7165fbea28e080" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "flac"
  depends_on "libmusicbrainz"
  depends_on "neon"
  depends_on "libdiscid"
  depends_on "s-lang"
  depends_on "unac"
  depends_on "jpeg"

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ed0e680/flactag/jpeg9.patch"
    sha256 "a8f3dda9e238da70987b042949541f89876009f1adbedac1d6de54435cc1e8d7"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "LDFLAGS", "-lFLAC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flactag"
  end
end
