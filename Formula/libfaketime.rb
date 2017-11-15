class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.7.tar.gz"
  sha256 "4d65f368b2d53ee2f93a25d5e9541ce27357f2b95e5e5afff210e0805042811e"
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    sha256 "e8a7ff71909cecf866a16051bb9a10c492d7f01ea096bc76870ee56af78aa1e7" => :high_sierra
    sha256 "14232fbbb6c53452c81f4fb0b1cfb90930b92f643f9969a7fea9b513beb5bf54" => :sierra
    sha256 "f2cb815d9c1d79592764ad6f2a3061205679b14e056f2f8ece3451c9fe0ba1b4" => :el_capitan
  end

  depends_on :macos => :lion

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install "src/faketime"
    (lib/"faketime").install "src/libfaketime.1.dylib"
    man1.install "man/faketime.1"
  end
end
