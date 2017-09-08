# From: Jacques Distler <distler@golem.ph.utexas.edu>
# You can always find the latest version by checking
#    https://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h
# The corresponding versioned archive is
#    https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-x.x.x.tar.gz

class Itex2mml < Formula
  desc "Text filter to convert itex equations to MathML"
  homepage "https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"
  url "https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-1.5.6.tar.gz"
  sha256 "e042fd0aa6e0cab09b28f9332e9f22c5f2b9bc94100386d70c105e7cf3eddf70"

  bottle do
    cellar :any_skip_relocation
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
