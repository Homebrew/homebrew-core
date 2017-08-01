class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"

  stable do
    url "http://www.catb.org/~esr/ascii/ascii-3.17.tar.gz"
    sha256 "94e55080fa20168cb9501693d7715869f329a7be1e74de0bd55faa493ee25445"

    # NEWS file is needed for the build but missing from the release tarball
    # Reported 31 Jul 2017 to esr AT thyrsus DOT com
    resource "NEWS" do
      url "http://www.catb.org/~esr/ascii/NEWS"
      sha256 "b743afe2b21f88beb0d0cfb732ed3c4cb646ce37a7017c82f99e8d92149bfd33"
    end
  end

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
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    else
      buildpath.install resource("NEWS")
    end

    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output(bin/"ascii 0x0a")
  end
end
