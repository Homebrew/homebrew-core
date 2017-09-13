class Libident < Formula
  desc "Ident protocol library"
  homepage "https://www.remlab.net/libident/"
  url "https://www.remlab.net/files/libident/libident-0.32.tar.gz"
  sha256 "8cc8fb69f1c888be7cffde7f4caeb3dc6cd0abbc475337683a720aa7638a174b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4fb8a991f9f83d499b32a814b2d68465327b7b77c0108764e58e4296a968100f" => :sierra
    sha256 "6236d3b4ee424795859cc64da30997ff67f7ac5bd42702e8eabe10f99339ca48" => :el_capitan
    sha256 "53db8e889d8efa34b4a3b6a145bcec2bcb53595e7db0cfdd55c8d857dff3a442" => :yosemite
    sha256 "d8e20cc9d2015b83785d4eb05110afc082a6389267df82546cc89e693dd2db6a" => :mavericks
    sha256 "0bb13ba0c69e3bcf77da2edaac0b500c074724a7a191674bc2914525dbf7dcd0" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
