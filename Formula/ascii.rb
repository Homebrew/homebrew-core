class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.18.tar.gz"
  sha256 "728422d5f4da61a37a17b4364d06708e543297de0a5f70305243236d80df072d"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c106e2d3ce3534f09a5ce147f6fc0778e884d06f15e7c272ee99ccabaf947bd" => :catalina
    sha256 "d5f4c8fe4ad1467c1708e49268a42f0d201f8c18ed912cf3de330bdf1f219cc1" => :mojave
    sha256 "858e5bd8f55367349f936f47346a7d4dc2afed7c8f3d9fca16c42071f537f644" => :high_sierra
    sha256 "52fb2a78a1409f4f6db0b59589f773c4427c87a84a7fee1809e5f0a4d50e4d65" => :sierra
    sha256 "bbb5f365f96e42dfaa8af31f21daa8809b0a628451599fab7bc7509ceeb0d14f" => :el_capitan
    sha256 "ab520ebbe64a946a0ac0466537a0e207e49cd85979e41582ab542dcaef9db3ff" => :yosemite
  end

  head do
    url "https://gitlab.com/esr/ascii.git"
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output(bin/"ascii 0x0a")
  end
end
