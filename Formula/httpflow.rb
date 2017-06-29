class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.6.tar.gz"
  sha256 "8a462e7c56a00c039cf35aae8f983350b4a88a8e2a9a40614e1584ec8fe7aa1d"
  head "https://github.com/six-ddc/httpflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54424d3b3df0f9e0667e23879ab493938b61b40c0a81b0c1a6f5551a373e6254" => :sierra
    sha256 "d1a956d95729f71d43e9d13740a9a38950f5c05e2c8af83362c3afcc35d3762b" => :el_capitan
    sha256 "4ef84470498e7c1f86bc6962073f5e97a00049268823d3fa313087c21bc26deb" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
