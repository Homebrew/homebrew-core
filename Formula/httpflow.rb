class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.9.tar.gz"
  sha256 "2347bd416641e165669bf1362107499d0bc4524ed9bfbb273ccd3b3dd411e89c"
  head "https://github.com/six-ddc/httpflow.git"

  bottle do
    cellar :any
    sha256 "b9e4d694b806f3a4201ac691b680a9cbd21a465de018ba28aa944e9ca869d848" => :catalina
    sha256 "7284170097a075c1831a5ae8cf3ad128f4a3352392d57b65ce5b375f2324449b" => :mojave
    sha256 "4d369eb896c76cd1895e6f363779499387bae50053c36445adafbd23ba5f722a" => :high_sierra
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
