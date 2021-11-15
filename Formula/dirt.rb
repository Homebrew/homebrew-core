class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/tidalcycles/Dirt"
  url "https://github.com/tidalcycles/Dirt/archive/1.1.tar.gz"
  sha256 "bb1ae52311813d0ea3089bf3837592b885562518b4b44967ce88a24bc10802b6"
  license "GPL-3.0"
  revision 1
  head "https://github.com/tidalcycles/Dirt.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "82bbbe42458acf9ec7e5f628eae3aaa8e8c9df057e083ff45e044e0a64339c88"
    sha256 cellar: :any, arm64_big_sur:  "c011771c2775cdbf313084355baf6734da930ad9fae75326775cfb27481482a4"
    sha256 cellar: :any, monterey:       "dc6f8629d3cbdd9157fa9445ad7bcab0058cc286d042f7830c42c6c28e90190a"
    sha256 cellar: :any, big_sur:        "ac69059e87e5682411a7442619985d95d79ee67af88366bcea28cc89e35ef46a"
    sha256 cellar: :any, catalina:       "2e9cf5a28852453f9ec5394bb2218fe3366e2cc6ef133e2dda847fbfa71ee968"
    sha256 cellar: :any, mojave:         "f90972cf61d77071fec9ab429f8a88a03738699b7e223b30c8655d5c64fede74"
    sha256 cellar: :any, high_sierra:    "b889891f8186b244161241e9c81d20afad20c31bd592fbf6860658334f314d39"
    sha256 cellar: :any, sierra:         "63847bffb4de9fa0cf57a1aea8a6bc1d713b8b0a1243ada27e6dd9d4aa21ccc1"
    sha256 cellar: :any, el_capitan:     "96b6e1e120bb8be5a051cdca4534d569afe5cae61abdcaf808cdef7af94042af"
    sha256 cellar: :any, yosemite:       "ae94ee15ddb686a63120bea12e2991a5357711fcfcf0ed5c09f7aa6e2d6c3a4f"
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
