class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/tidalcycles/Dirt"
  url "https://github.com/tidalcycles/Dirt/archive/1.1.tar.gz"
  sha256 "bb1ae52311813d0ea3089bf3837592b885562518b4b44967ce88a24bc10802b6"
  revision 1
  head "https://github.com/tidalcycles/Dirt.git"

  bottle do
    cellar :any
    sha256 "f90972cf61d77071fec9ab429f8a88a03738699b7e223b30c8655d5c64fede74" => :mojave
    sha256 "b889891f8186b244161241e9c81d20afad20c31bd592fbf6860658334f314d39" => :high_sierra
    sha256 "63847bffb4de9fa0cf57a1aea8a6bc1d713b8b0a1243ada27e6dd9d4aa21ccc1" => :sierra
    sha256 "96b6e1e120bb8be5a051cdca4534d569afe5cae61abdcaf808cdef7af94042af" => :el_capitan
    sha256 "ae94ee15ddb686a63120bea12e2991a5357711fcfcf0ed5c09f7aa6e2d6c3a4f" => :yosemite
  end

  depends_on "jack"
  depends_on "liblo"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dirt --help; :")
  end
end
