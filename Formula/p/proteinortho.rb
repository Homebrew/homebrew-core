class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.0/proteinortho-v6.3.0.tar.gz"
  sha256 "9b0142d29d22a35732b17be2ce125ccbc7d711edc4bb8caf1ffc808eb16975f1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03feb8fd8d22bd96bef31bebb693699e949cd49d5a7d0d76b43d557017e27f42"
    sha256 cellar: :any,                 arm64_monterey: "79036ba9dda0e863405ecf1689590eb2ef1ae52869dd5def7e7df7336351d11c"
    sha256 cellar: :any,                 arm64_big_sur:  "a883c0b0b2485ea09f0c3e0e2f0388ce11cb86badfe896b28bf1796174cf5ad0"
    sha256 cellar: :any,                 ventura:        "f069971d269a43ffeebb33ba8ea807c45e23957cd5fca4a54ec5e154191cd7ff"
    sha256 cellar: :any,                 monterey:       "86386d0905b15018af54fa32324b92b0e948a6bdc7a69aa583726db6200d49af"
    sha256 cellar: :any,                 big_sur:        "31e9ef8017aed1e10b1c10bcb5d9ec0fccab0bbce3d9c387a564b82504edff6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8720b076cdd3c3cc4e00e48538f40e3437e64382df2a7aec6c02924a06099dc8"
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
