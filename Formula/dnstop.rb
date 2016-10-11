class Dnstop < Formula
  desc "Console tool to analyze DNS traffic"
  homepage "http://dns.measurement-factory.com/tools/dnstop/index.html"
  url "http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20140915.tar.gz"
  sha256 "b4b03d02005b16e98d923fa79957ea947e3aa6638bb267403102d12290d0c57a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dc995c2857fdd5093ae753844ce5c45ed00bae59184528a184e0313b25882802" => :sierra
    sha256 "1d5b1ad056475ce9a27f40b48cbbf58421e4eb66fd134ac318413de2d025db66" => :el_capitan
    sha256 "aa3b72d1432e7c13b9b7e0722cde3f7fafef17aff557489662029698929638dc" => :yosemite
    sha256 "4a57a6144a94b3eb2cce64ec7f8f97447eafd1c0be2c5789593920d045e9a189" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "dnstop"
    man8.install "dnstop.8"
  end
end
