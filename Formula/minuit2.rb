class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://seal.web.cern.ch/seal/snapshot/work-packages/mathlibs/minuit/"
  url "https://www.cern.ch/mathlibs/sw/5_34_14/Minuit2/Minuit2-5.34.14.tar.gz"
  sha256 "2ca9a283bbc315064c0a322bc4cb74c7e8fd51f9494f7856e5159d0a0aa8c356"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "28baba24aef52eff45f8411d04bbdfa795dcbd9cc4c9d9c71f9eb71213b60ddd"
    sha256 cellar: :any, big_sur:       "92436bedd07967e01f4b230599680a6fc8220c43d6ee377aca4e7d824aa4eae6"
    sha256 cellar: :any, catalina:      "94d14435083239aeca25cc36037c4c1445d7327c9e28f216dfdbcb3be16525ec"
    sha256 cellar: :any, mojave:        "19ea9f2a3b94afe2902e02a71281d85268c5e63c46c9df822d9ac138211f6cc5"
    sha256 cellar: :any, high_sierra:   "61b38bc01bf0744908bfda8e610ca39f7f07b4e2d6ecd1239cb0de82521ae375"
    sha256 cellar: :any, sierra:        "00867c4037d0110f2adf23a623aa918a95c9345be197ecdc0a9aa0d9da9f04e0"
    sha256 cellar: :any, el_capitan:    "7457852262758583daca3f23ac3e6fa312fe0a3fd84f0b20da2081967124a0fc"
    sha256 cellar: :any, yosemite:      "32ff2d05e0a85b28513789e1f625e654f2141b80202f506ad0f7721caab95ddd"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-pic",
                          "--disable-openmp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
