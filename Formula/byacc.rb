class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20210328.tgz"
  sha256 "8b8f258eb22a4eae994ee374a712dd08e023cde1c39b373e8db8ba7806c50585"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8893ed78ff7c45e04651cbd56e5b4acd1e3f09cbee425615516f7a4f7e305d8c"
    sha256 cellar: :any_skip_relocation, big_sur:       "f622ecf64a8e634f59004fa158f67bd707779557fa50ecc7f394e4d62c046614"
    sha256 cellar: :any_skip_relocation, catalina:      "d96b70d8631bc6feffabef7e00d98b5f41b00a49c9542cf6390f561dcb3bcd32"
    sha256 cellar: :any_skip_relocation, mojave:        "e9422616cbec15f16ab180fc1fcfbabd9680a2a06f8163c1483c25f18cfe3a2f"
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
