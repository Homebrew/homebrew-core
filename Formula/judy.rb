class Judy < Formula
  desc "C library that implements a sparse dynamic array"
  homepage "http://judy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
  sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"

  bottle do
    cellar :any
    sha256 "97d8cb15b7928d947c66da593586210b7de1135b03d59bb3dc335f205c14ae01" => :el_capitan
    sha256 "472f41fb2299ea55a2b1a0a8ea9b7ade2fea97bb37c978ba8c1912ead798d8ee" => :yosemite
    sha256 "1c1d511152bcc6b0f992cc2d6ca78a88304f70706873477220bc7c3d1743504f" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Doesn't compile on parallel build
    system "make", "install"
  end
end
