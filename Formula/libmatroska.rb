class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.9.tar.xz"
  sha256 "38a61dd5d87c070928b5deb3922b63b2b83c09e2e4a10f9393eecb6afa9795c8"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    cellar :any
    sha256 "9cf80937bba8b956bd15e78252ef23cc06afa902c3594baa3a3337aa26f7a1e3" => :mojave
    sha256 "04ec9b92408b8b08f201ae9e31da5d9abd0383a468938b999007ec51530fa50d" => :high_sierra
    sha256 "8f8b94c254e55a0c79aae5d9ad6a3ea60e16caca379594d8613c5d92f9e8dc00" => :sierra
    sha256 "8df1a83ae264b0597d714f843e2b3d322be80a30ea0f0400dc86fed6b5d6c0ee" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end
