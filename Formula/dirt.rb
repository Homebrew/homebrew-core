class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/tidalcycles/Dirt"
  url "https://github.com/tidalcycles/Dirt/archive/1.1.tar.gz"
  sha256 "bb1ae52311813d0ea3089bf3837592b885562518b4b44967ce88a24bc10802b6"
  head "https://github.com/tidalcycles/Dirt.git"

  bottle do
    cellar :any
    sha256 "5aaea5c14a78188d7e8d03b0935254238be2775ea473c2b0ca014134e023a9f9" => :sierra
    sha256 "b1a17908e39a4ac31d147f52477a60b538c9c4b9f14caf4b3e6fa26a09e11d03" => :el_capitan
    sha256 "2600455e336a98af56559766a30c38baa04539b5c3fc087285af12931db84e0b" => :yosemite
    sha256 "5191aa383bb7edf3a85122140d8ebd6113ab56a851ac8d35e09e086632f8eb9c" => :mavericks
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
