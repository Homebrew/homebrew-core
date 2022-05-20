class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1.SVN"
  revision 3
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    sha256 arm64_monterey: "fd608b01aa958d503f590b029525209ddd4d0e6817e4f722cf978e853d7555c4"
    sha256 arm64_big_sur:  "95ec2ac797371b95af51822a496d20698a12ae3634957caffdee0960cb791be2"
    sha256 monterey:       "32b9463d445e6655142662879346d4e6e19d4acc3df20cf79ee7d04d08763fbf"
    sha256 big_sur:        "ec7e854d2bfa8853265051a3979e5dd49e357f5ae3a92fba709ba87016cfc4ac"
    sha256 catalina:       "46cb29e00532a085978e00fa78a763b0273a7722e670f97ea1bd779c554cda62"
    sha256 x86_64_linux:   "2abd98ef2ba46b27da1b058174d93bc41ea3707c0dc444c1203117fff43071bb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match "Forced opening move", output
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
