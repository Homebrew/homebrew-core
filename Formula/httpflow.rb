class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.7.tar.gz"
  sha256 "9bcc7bc00427a4b01c5a5178113780f2321fbe2f81857c915a420df3a6b41de2"
  head "https://github.com/six-ddc/httpflow.git"

  bottle do
    cellar :any
    sha256 "02f297152a11c184e4b16e3881d416f9cd388ecab8a4979a02bf0bbf6f2c4f56" => :sierra
    sha256 "aae82cdbdfbda4766e7ac39ac7cf0d588ae05379b6de60fe9a62521eaf097f61" => :el_capitan
    sha256 "f1f6b80b4d0ae25da4bc0b626ce3da653ad48f55c4d9e82c3e60ec51ff6ddea4" => :yosemite
  end

  depends_on "pcre"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
