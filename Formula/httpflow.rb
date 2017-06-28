class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.6.tar.gz"
  sha256 "8a462e7c56a00c039cf35aae8f983350b4a88a8e2a9a40614e1584ec8fe7aa1d"
  head "https://github.com/six-ddc/httpflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eaed64a4fad883f5085131bdc8584e83044ac6b2282daa110e3decf94ae11a7e" => :sierra
    sha256 "3f64470510030ce9fa0241ae229619fb6c1ca99bffb72826ab63b6d343f7ef8f" => :el_capitan
    sha256 "159bb97cf4d34ae30506fb5ce854231e95423ecd904d985ae1c4ee43e81dca6c" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
