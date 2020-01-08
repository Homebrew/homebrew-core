class Nuttcp < Formula
  desc "Network performance measurement tool"
  homepage "https://www.nuttcp.net/nuttcp"
  url "https://www.nuttcp.net/nuttcp/nuttcp-8.1.4.tar.bz2"
  sha256 "737f702ec931ec12fcf54e66c4c1d5af72bd3631439ffa724ed2ac40ab2de78d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "30f53416222f980f2020a0640a6cd62ca31038ea48b8aea06157b927aee04bae" => :catalina
    sha256 "82951677c224a70e463033f266791122d7419dd5308bef61da5474738151497b" => :mojave
    sha256 "bb494c46c81a914bb8eb66ad4476c2503e0345fc8f9dcf82c5cd2576fe005869" => :high_sierra
    sha256 "9f4ca632e04e072eea5d17a54cd42e22d63ef7902e452d1133d42fea0ca2f829" => :sierra
    sha256 "c38cac9cdf461d9f44a34dc1c7db83909a38faee07c1f5c43af3a4f816527493" => :el_capitan
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
