class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.38.2.tar.xz"
  sha256 "28b22f9c9d71d6143bcc8bbb1611d754a581aa818e0554ce828b3ce812915d69"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "9b9c5d38300e6f66f05d8eb542b75a5a9edefe5b110467e6c1eea5948a10d5f8" => :sierra
    sha256 "4b6a8d3a5d6ab675884c034cffa0aa68ee9597bb62d9566b8f649d37671aa144" => :el_capitan
    sha256 "42683cffddd096b7d4e9225d4290498451055c32dcacea2c2b783485e0c77a07" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
