class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "https://hewlettpackard.github.io/netperf/"
  url "https://github.com/HewlettPackard/netperf/archive/netperf-2.7.0.tar.gz"
  sha256 "4569bafa4cca3d548eb96a486755af40bd9ceb6ab7c6abd81cc6aa4875007c4e"
  head "https://github.com/HewlettPackard/netperf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "da28e83fa25e8284ee5acc7fa327d886bb53ab20035cd07703909b7556ab25e1" => :catalina
    sha256 "cdd840b5e300383245d703973fcd238d58b4bd89d2ae3ba6769db297b2ddb1f9" => :mojave
    sha256 "cf086e0d276a572aba8318f7080cedc94b36a7b612cdbb4bcc3ceefef0080c53" => :high_sierra
    sha256 "4d3f648081c84ad697d608b56bcfce3237de7c34c4e4a53d9851628f9d50cd5d" => :sierra
    sha256 "c6e96625b1f83a7f83d3c9b53b8584ab65d73cfd59bc38672588ba82d37ecc1d" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end
