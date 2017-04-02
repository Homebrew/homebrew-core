class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.4.tar.gz"
  sha256 "0926e22690bb65d81d8bfd4d1794ded69ca057731d4fd7b68ed60b840f9d3ecb"
  head "https://github.com/six-ddc/httpflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f891030451e9420e382589655ae740eb55ecbe8b76b2df5e9d54085fdf157c6a" => :sierra
    sha256 "93eb3e83c82dd815f46b9c59999c7e43e59e99a8745d804006983ad954f1988d" => :el_capitan
    sha256 "6a7c2f89c1c70c7cd5fa12d9fdfbe537c9dc820ca1ced8ac5dfb428954ad91b4" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
