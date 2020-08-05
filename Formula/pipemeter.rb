class Pipemeter < Formula
  desc "Shows speed of data moving from input to output"
  homepage "https://launchpad.net/pipemeter"
  url "https://launchpad.net/pipemeter/trunk/1.1.3/+download/pipemeter-1.1.3.tar.gz"
  sha256 "1ff952cb2127476ca9879f4b28fb92d6dabb0cc02db41f657025f7782fd50aaf"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe84476d7d258a2e5f02df94a90e59faafdcc8ed4b1277c6a4347c1de85114f7" => :catalina
    sha256 "2e8cc64e9e25c27c2c18680f22f59b68962740d04f6f80c9406ca915747ae990" => :mojave
    sha256 "977077866b51a7c0620fe036431ea207b72d38bc383422d682dbfde40a90d6a6" => :high_sierra
    sha256 "19c2d3933e5d0ac8e80559ae77ea09ad83bb8746ebf313d4cdd8a30374eadaa3" => :sierra
    sha256 "bf99d50927a1277c1a481af0eea25314dfbd1449dbd1394368f7a933da367e9a" => :el_capitan
    sha256 "cee0b494c5f7647d0c597e90dbc8be2c7b759d53a12cd87f89f9620b9260c3ac" => :yosemite
    sha256 "a1bd1a5466eb44aeeba7ab2563f3bd34978d248deec50964624f985f066fe2bf" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # Fix the man1 directory location
    inreplace "Makefile", "$(PREFIX)/man/man1", man1

    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    assert_match "3.00B", pipe_output("#{bin}/pipemeter -r 2>&1 >/dev/null", "foo", 0)
  end
end
