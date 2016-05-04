class Pelikan < Formula
  desc "production-ready cache services"
  homepage "http://pelikan.io"
  url "https://github.com/twitter/pelikan/archive/0.1.1.tar.gz"
  sha256 "24a84bd9be7bb25da507a355b7ed3a35f7cb2a8c9447092f5acc91ff32f98775"
  head "https://github.com/twitter/pelikan.git"

  depends_on "cmake" => :build

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pelikan_twemcache", "-c"
  end
end
