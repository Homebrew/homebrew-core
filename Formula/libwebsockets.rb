class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.0.1.tar.gz"
  sha256 "f98cf9e35385863cfe64a5f181403bf3113cc5d82604c4811e1373ba8676ef88"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "2479ab31e046ae0ff45b48ae5239cedca875e0c7986463f7a1e33b7c29fd9132" => :el_capitan
    sha256 "cc661dc04f206bed0fa7ad223dea38caddd1bcc1a6326b4a6389d3431784ae4e" => :yosemite
    sha256 "0c2ac36a235581f64349501c42796c2a08aea85faedb5080b62cf173d2daa506" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
