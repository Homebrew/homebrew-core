# From: Jacques Distler <distler@golem.ph.utexas.edu>
# You can always find the latest version by checking
#    https://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h
# The corresponding versioned archive is
#    https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-x.x.x.tar.gz

class Itex2mml < Formula
  desc "Text filter to convert itex equations to MathML"
  homepage "https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"
  url "https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-1.5.7.tar.gz"
  sha256 "3e0435c3ebcd5366d0d285ca194cfccc0b9c28e3e3ae5d92c9d1b47c854a5d7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbde9f69817db94e285baa589da3dba6c17ae3e687a010299a5e75b756fe2cc9" => :high_sierra
    sha256 "3f6a90721009d85d73da62e19f631c952d4bdde2f453e9063142d9f31dbd18b2" => :sierra
    sha256 "92672111605c45335e766314e1e38c40274fdcbafce169af609ae36b152427ce" => :el_capitan
    sha256 "522ae0c41c16a63c82d047c9c6239e5359cc5687af2dabaa837ff629da835e8d" => :yosemite
  end

  def install
    bin.mkpath
    cd "itex-src" do
      system "make"
      system "make", "install", "prefix=#{prefix}", "BINDIR=#{bin}"
    end
  end

  test do
    system "#{bin}/itex2MML", "--version"
  end
end
