class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.9.tar.gz"
  sha256 "2347bd416641e165669bf1362107499d0bc4524ed9bfbb273ccd3b3dd411e89c"
  license "MIT"
  head "https://github.com/six-ddc/httpflow.git"

  bottle do
    cellar :any
    sha256 "8fd53a648dc88731b9dc6dd03fbfa68302f287e8c3eb2685273f10d691aee13e" => :big_sur
    sha256 "4ad73cc6cd313d17634e78df0795ce7ad85b929e05efaf219768e9929950a663" => :arm64_big_sur
    sha256 "2b7b63f5d82139b4fc017b8848e3b29608738cd510ef1350710c6224a24079a3" => :catalina
    sha256 "6d911ff1c720035b0b23cf994fbbb37e7d1372dcd32eb60bc54924b78b444431" => :mojave
    sha256 "cf54de7d5e6fda49966d75a0c33580bb8e64d3d0fb6c39337a03e21fb20682d5" => :high_sierra
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
