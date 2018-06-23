class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.11.3/fswatch-1.11.3.tar.gz"
  sha256 "21f60ff255bd8dac72c8eb917b08c10ef2a040b380876a35357f6a860282ac83"

  bottle do
    cellar :any
    sha256 "542ed7f8f6b66806524a6ddfab9c9be79d98d741a0cae229bb8e76829f17f954" => :high_sierra
    sha256 "772fe9d50aff488e4cbf24af9d15c0f1fafe6629abb12d107d850cf4c751264c" => :sierra
    sha256 "087d3325d1faf25c8f1b25920a25d169c255bc17ee357e4734c2b999139bc0ce" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
