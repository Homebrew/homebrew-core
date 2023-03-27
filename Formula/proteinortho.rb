class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.2.3/proteinortho-v6.2.3.tar.gz"
  sha256 "8bdf788b612064d02f30db9c7c9fed6f35040710bf611d01c467f05f4d6befe3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "329aa1084ebdc27da46598648bb22b4b2bd6305f0e2c0d159f63b1a04840f146"
    sha256 cellar: :any,                 arm64_monterey: "294d35b617a286957405f950333edb61eb5bf3fe7987dab00a34c2b1a940cddb"
    sha256 cellar: :any,                 arm64_big_sur:  "693eed273559f017474fb8f6a60a79c3e88afcde37612d3533a9e911e7bf2ae0"
    sha256 cellar: :any,                 ventura:        "daeb477d826cebfa6dccfc1fea62c9376e802692eed395fee3cc779365d3cf10"
    sha256 cellar: :any,                 monterey:       "bb89e9fef79e7450f21662150718a8eb64e3817f4cf2c12ddf3f588e6b42676b"
    sha256 cellar: :any,                 big_sur:        "102f7881309ca660d0fe61c9f7edfadeb8b8a3bb01c72f87d9b21f0ea626eeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93746105d214be28cd0088a925895dd7477c4d1dc4bb3eed82fb7ca6bd1932f"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
