class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.27/proteinortho-v6.0.27.tar.gz"
  sha256 "bf8a1e6163bfb184db03a2b1210dc94899766e416f3083ca347a5044903c7e6e"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "991bd14386381543bb06a3b4d7288b31e51d0e2944649f853cc1b3733eb1030d" => :big_sur
    sha256 "24042f356fa58ee7b5bcc2c83badcb10ab644c3c182f9960d89dbb8e46ad0676" => :arm64_big_sur
    sha256 "f1139517d77eafef09b06652ffd77b4c5c9c478ff1e2d1050d3f01235e2a3efb" => :catalina
    sha256 "0c8b2794a7bb3b97c897c7bd7f13fb60e62728297f8e8dfd9ec0935d3957d144" => :mojave
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
