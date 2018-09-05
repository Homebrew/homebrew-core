class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.6.tar.xz"
  sha256 "1e5a7a7820c493aa62b0f35e15b4233c792cc03458c55ebdfa7a6521e4b43e9e"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "c5eaab8eb2764372cc9e6a1b65d34d88bb574d2ca3abd3e09ee4fec68bbe5646" => :mojave
    sha256 "a01d2e280ab7a8d66fb011d76a561418efcc405b77bfbb6aa7c4ed8cdf50d801" => :high_sierra
    sha256 "42290383556da8468940edb695037091cc85e96883a3e41e9751e2f28033868a" => :sierra
    sha256 "9783de8ef94b13ed3660eb99a821e221ae1f72d0e52397c1bf96e408d2d0654f" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
