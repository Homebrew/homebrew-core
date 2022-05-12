class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.35/proteinortho-v6.0.35.tar.gz"
  sha256 "1aa4a887d82a1074f1032d5a56858b35505d4c9937080a4f366fbdcc83e483d3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2b2ffbe18ad1ddf68f5ac6a287263295c18399cd8dd0d61366db0c02cb62bfd8"
    sha256 cellar: :any,                 arm64_big_sur:  "353ca6964c05e0c0dad3c3d8522a1d2a7091b36d9b0ec0210b7829352e4a2373"
    sha256 cellar: :any,                 monterey:       "f9d51e1086df9b04f429b291ee727d404ee4b8dbfbd9198a85f1116ff3a607de"
    sha256 cellar: :any,                 big_sur:        "7ab64514f98900e9a6878b94b6f9c3242d6e0e6e4acdf2ab12df96756989be8e"
    sha256 cellar: :any,                 catalina:       "905d8f762147dfc6cc04bd7dfceab6ca858299f8b6dbc70d8567625ebbd1cdb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e7fbcebe78f36044cad765973f1f32687c79dd13fe76f529bc6988be16bd004"
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
