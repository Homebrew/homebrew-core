class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20220101.tgz"
  sha256 "a796ce90e960bf18d256eba534b9bd1e394d394a141ee63f530cab1074615b67"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e964c3d8815a2361bf7e6ad27031268a7b74811de2867374dc1c49725f4fb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "084afc1b619e0ec7236b59706e70c7de7450f4b20075c48255d1a9b55533a9f3"
    sha256 cellar: :any_skip_relocation, monterey:       "008f11d145ac6c010c2bfd5f05ae4318b30f07c49a1ae073beb9edc2ccfa804b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f5d2a7c7566e7bef71c8bb5dcdc970dbe339e10ed19484479c1bc776e325675"
    sha256 cellar: :any_skip_relocation, catalina:       "f71fd646f60e452b9c457ae3211af2107464b7921b92414439c2c6cc61b5fc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906260849c7750342e4f4217f75e22d69975f26342ff381772360103c252039a"
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
