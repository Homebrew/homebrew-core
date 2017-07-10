class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "http://invisible-island.net/byacc/byacc.html"
  url "ftp://invisible-island.net/byacc/byacc-20170709.tgz"
  sha256 "27cf801985dc6082b8732522588a7b64377dd3df841d584ba6150bc86d78d9eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fe9ae7c9e17d4c86b482c1687154a0505d3789aaef27ecb7447020a97fed735" => :sierra
    sha256 "db200946b47757fa0dacf8a4c5869b02b44a77277406f9a4d9ac9927b3ddbc03" => :el_capitan
    sha256 "b9d1cf3f27f5b0e32d41a5838057779953f5642ebf0bcf7c15a03193a3e14568" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
