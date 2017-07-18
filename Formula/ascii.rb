class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.16.tar.gz"
  sha256 "a94bb3970e8f1f63566f055517aecbdd46b11c4ccf142f77ffb80a79994f03a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff21b9c17c8c80a0c9c675cab06e342e62fa32fb4d3d5885c6bb7f8f0ea0cfca" => :sierra
    sha256 "d2a31c1e0de81dbae47fe587471ed8bd16e1d5d665c312ec4d04de27cc926c97" => :el_capitan
    sha256 "2ecf284b12789cc7efbe63a294792c932ccb2ef9e38b12acd05ac33e246cd296" => :yosemite
  end

  head do
    url "git://thyrsus.com/repositories/ascii.git"
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
