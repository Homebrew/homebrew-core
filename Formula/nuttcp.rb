class Nuttcp < Formula
  desc "Network performance measurement tool"
  homepage "https://www.nuttcp.net/nuttcp"
  url "https://www.nuttcp.net/nuttcp/nuttcp-8.1.4.tar.bz2"
  sha256 "5c5f4f6ae04adb8a86d11e1995939c1308b90e1946ebc77c9988b5eb85961bb5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bb9ab2f301204e093c71fb5d78fb940b8721adbfc4435e8887850a8f4582159" => :high_sierra
    sha256 "478522cb3e50128eb9b7b09d519bfaa553ae05025d1708a3d5d0c7b76dcbac8a" => :sierra
    sha256 "7fe34e31cd50393b055dde913785931696bb332bc1b5948720d7817e1247151c" => :el_capitan
    sha256 "18cfa8910325006d83e53c94a845d611704ce882f3f48a5edd2ebc6e75def200" => :yosemite
    sha256 "57c31d24a43302c4fb1b08f6a17a05da60c3486a52481b0580c3e1f5d75c7eaa" => :mavericks
    sha256 "e289d316c0aea0a8b1a85bde5f72f648cfe2dbae26a9fee4f7614ccdd7aa983a" => :mountain_lion
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
