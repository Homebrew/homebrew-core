class GoogleSparsehash < Formula
  desc "Extremely memory-efficient hash_map implementation"
  homepage "https://github.com/sparsehash/sparsehash"
  url "https://github.com/sparsehash/sparsehash/archive/sparsehash-2.0.4.tar.gz"
  sha256 "8cd1a95827dfd8270927894eb77f62b4087735cbede953884647f16c521c7e58"
  license "BSD-3-Clause"
  head "https://github.com/sparsehash/sparsehash.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11390608ee72647c06a9735f89535604e6ed2b2531431f9eb81bdf423ab07620" => :catalina
    sha256 "11390608ee72647c06a9735f89535604e6ed2b2531431f9eb81bdf423ab07620" => :mojave
    sha256 "11390608ee72647c06a9735f89535604e6ed2b2531431f9eb81bdf423ab07620" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
end
