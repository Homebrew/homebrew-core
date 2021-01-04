class Netcat < Formula
  desc "Utility for managing network connections"
  homepage "https://nc110.sourceforge.io/"
  url "https://sourceforge.net/projects/nc110/files/community%20releases/nc110.20180111.tar.xz"
  sha256 "9c223f2472fc5b0d77c29a88536913e6573217cbc028dd276c30e689feeb182d"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ec93ed2ce809a78373e1b747f20075fabe5e9d612e2f84f85f125e4ce81eadb3" => :big_sur
    sha256 "13bd349dfb08b3a5a474498eec4e20ffff722f82446b255d9c6e0540b02b362b" => :catalina
    sha256 "3ac133de6b67a147954d78b9bd0c4c4cf4e0f43bdbbb98f51d8d962bb752d973" => :mojave
    sha256 "879d9c32f09e9ef31cb672983707f9d95341f6639bb8a4db54d7a6ea0878b946" => :high_sierra
    sha256 "9027fd429d5407fba0b3206bd0cd198c669f4744155efcf8e0dbdd6ba69b6d34" => :sierra
    sha256 "1f346605e0236ea7880258da2abf0bde1d7d8d8735a07d6d32feaf12425ff6da" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
    man1.install_symlink "netcat.1" => "nc.1"
  end

  test do
    output = pipe_output("#{bin}/nc google.com 80", "GET / HTTP/1.0\r\n\r\n")
    assert_equal "HTTP/1.0 200 OK", output.lines.first.chomp
  end
end
