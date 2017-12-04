class Nuttcp < Formula
  desc "Network performance measurement tool"
  homepage "https://www.nuttcp.net/nuttcp"
  url "https://www.nuttcp.net/nuttcp/nuttcp-8.1.4.tar.bz2"
  sha256 "5c5f4f6ae04adb8a86d11e1995939c1308b90e1946ebc77c9988b5eb85961bb5"

  bottle do
    cellar :any_skip_relocation
    sha256 "80b4a1b94e21a1b94d960fefddfbe235597ccc687f3f815a7aee989fb0d53a07" => :high_sierra
    sha256 "50f44fadb6a471f65fac82065681ed42b44cf1c6ea78680db9e0ade3725577a0" => :sierra
    sha256 "6b2eab6b736721543d321f9577ac8ee94c3cefd5026bb0d39084c4d721853249" => :el_capitan
  end

  def install
    system "make", "APP=nuttcp",
           "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "nuttcp"
    man8.install "nuttcp.cat" => "nuttcp.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nuttcp -V")
  end
end
