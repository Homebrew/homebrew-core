class Greed < Formula
  desc "Game of consumption"
  homepage "http://www.catb.org/~esr/greed/"
  url "http://www.catb.org/~esr/greed/greed-4.2.tar.gz"
  sha256 "702bc0314ddedb2ba17d4b55d873384a1606886e8d69f35ce67f6e3024a8d3fd"
  head "https://gitlab.com/esr/greed.git"

  bottle do
    sha256 "152ce580c6e8157f765217a537cab9fb05561433c9546696989eb5770c77ee3b" => :sierra
    sha256 "136edae12bcf18054cc5afeb7bd5f0d05ca8c6979f8764126a6216c174644e31" => :el_capitan
    sha256 "634db96b3c26b08026ea59b90e161af6ec0979f79dcdb5ca132ee49fc91b6cfa" => :yosemite
  end

  def install
    # Handle hard-coded destination
    inreplace "Makefile", "/usr/share/man/man6", man6
    # Make doesn't make directories
    bin.mkpath
    man6.mkpath
    (var/"greed").mkpath
    # High scores will be stored in var/greed
    system "make", "SFILE=#{var}/greed/greed.hs"
    system "make", "install", "BIN=#{bin}"
  end

  def caveats; <<-EOS.undent
    High scores will be stored in the following location:
      #{var}/greed/greed.hs
    EOS
  end

  test do
    File.executable? "#{bin}/greed"
  end
end
