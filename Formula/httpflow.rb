class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.8.tar.gz"
  sha256 "e2d4f233460a5a52cf64fb15adc574f521a85d0898f7d6306d3ad8ddd56a1493"
  head "https://github.com/six-ddc/httpflow.git"

  bottle do
    cellar :any
    sha256 "6e2dae55b26343cf1e384ab67e22d70c19162f09d28c96f02dcad2b96a70de17" => :catalina
    sha256 "602b0986019d2d669e91ccd4d43411b6c8ad52ae44feaaac6f19f57c5267a7f9" => :mojave
    sha256 "81bacec65a65a4f97be8035f1d21407ddada8bf3e8ab2dea8163f42162af6d65" => :high_sierra
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
