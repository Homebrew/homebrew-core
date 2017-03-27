class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.3.tar.gz"
  sha256 "26e8d1f8d6c0742b552bc333edd340dc3b3e3ad4590fe2e0e125d830142f0b37"
  head "https://github.com/six-ddc/httpflow.git"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
