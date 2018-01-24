class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://www.bastoul.net/cloog/"
  url "https://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  revision 2

  bottle do
    cellar :any
    sha256 "0e7b4e57d4336d0d166a6fdaee69cf1ce0a538a50e507ba3fae1394df382c7b9" => :high_sierra
    sha256 "b6e977e77cdca21680162b68e1f5d1f99bcd8b84c8ca030934fdda1f1b694b9e" => :sierra
    sha256 "9b7cfa81d80f6c2f5cc82353bc99bf0221c033ca1f9364d40becd31172fbb679" => :el_capitan
    sha256 "e6f939ce6727868c72f9110709a6d913a61c6aa55eaf892f3ccac41278728255" => :yosemite
  end

  head do
    url "http://repo.or.cz/r/cloog.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl"

  def install
    system "./autogen.sh" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-gmp=system",
      "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
      "--with-isl=system",
      "--with-isl-prefix=#{Formula["isl"].opt_prefix}",
    ]

    args << "--with-osl=bundled" if build.head?

    system "./configure", *args
    system "make", "install"
  end

  test do
    cloog_source = <<~EOS
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    output = pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
    assert_match %r{Generated from /dev/stdin by CLooG}, output
  end
end
