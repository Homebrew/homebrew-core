class Alure < Formula
  desc "Manage common tasks with OpenAL applications"
  homepage "https://kcat.tomasu.net/alure.html"
  url "https://kcat.tomasu.net/alure-releases/alure-1.2.tar.bz2"
  sha256 "465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71"
  revision 1

  livecheck do
    url "https://kcat.tomasu.net/alure-releases/"
    regex(/alure[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "3701d2ac280fd8ef5476343c348fec853397241cb2bdcaeb25e8a53b203d292c" => :catalina
    sha256 "f2ae4fbf2822241975e66574e41070b298523e6321280bc83aff70d559db149c" => :mojave
    sha256 "031b2eb61f6206879b76a7276298f1db9875fa996467327b519ccc6d1622a158" => :high_sierra
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
    output = shell_output("#{bin}/alureplay 2>&1", 1)
    assert_match "Usage #{bin}/alureplay <soundfile>", output
  end
end
