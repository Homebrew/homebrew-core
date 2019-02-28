class Alure < Formula
  desc "Manage common tasks with OpenAL applications"
  homepage "https://kcat.strangesoft.net/alure.html"
  url "https://kcat.strangesoft.net/alure-releases/alure-1.2.tar.bz2"
  sha256 "465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4b0683abfa113c033e779e61583dd9d8ced53e5a11a982da15e6ce13bcee742d" => :mojave
    sha256 "0e11aef02b6fe4ba7f47030ab2329d16766951f1aab15ea38fbff49119f9c946" => :high_sierra
    sha256 "ca92f4baba46fb0d6f33aca69e04215e7a867ebde1aa371938c3b81a34f9f2db" => :sierra
    sha256 "6dc7f359b7cdb67e741a48c276ba57e22d5b9c5d55d4881fcb798f52356c1a10" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # Fix missing unistd include
  # Reported by email to author on 2017-08-25
  if MacOS.version >= :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/eed63e836e/alure/unistd.patch"
      sha256 "7852a7a365f518b12a1afd763a6a80ece88ac7aeea3c9023aa6c1fe46ac5a1ae"
    end
  end

  def install
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"alureplay", test_fixtures("test.wav")
  end
end
