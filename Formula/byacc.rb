class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20200910.tgz"
  sha256 "0a5906073aeaf23ddc20aaac0ea61cb5ccc18572870b113375dec4ffe85ecf30"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "57aeaa751341ad11d735626ad343aaae7dbb9401697c917a4c7268241751e435" => :catalina
    sha256 "552cd6f3ad41dc11ddb8535b495594e7c63e9208e594f9bef29d317669512d6a" => :mojave
    sha256 "f8ea7c1fea86a6814bf332b8a35e81a19a28f380c4beb28d7bf0eabebe96cf78" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
