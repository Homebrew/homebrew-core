class Dromeaudio < Formula
  desc "Small C++ audio manipulation and playback library"
  homepage "https://github.com/joshb/dromeaudio/"
  url "https://github.com/joshb/DromeAudio/archive/v0.3.0.tar.gz"
  sha256 "d226fa3f16d8a41aeea2d0a32178ca15519aebfa109bc6eee36669fa7f7c6b83"
  head "https://github.com/joshb/dromeaudio.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "537401eb1346b32ad7474408f24853224d1874d7782c4980b0883855be8e153b" => :mojave
    sha256 "17e070192156e0e50f983a857110b1b9efcb5476dca7047adcdd151f9b14b81e" => :high_sierra
    sha256 "6a8617ee09ea859c079db275005a89d38738e497f07383ec2ba96b8df5c657f7" => :sierra
    sha256 "48f99a1a83ddf9d7ab3a3e6823a5bb715c8f781ad014727995ad8b8a8fc212bc" => :el_capitan
    sha256 "2d8165381db24b35e50cf29e6c745e05149dd2e00e8f1d0c61133a45355c3dc6" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    # install FindDromeAudio.cmake under share/cmake/Modules/
    inreplace "share/CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/DromeAudioPlayer", test_fixtures("test.mp3")
  end
end
