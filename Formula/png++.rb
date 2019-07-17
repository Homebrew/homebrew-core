class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "https://www.nongnu.org/pngpp/"
  url "https://download.savannah.gnu.org/releases/pngpp/png++-0.2.9.tar.gz"
  sha256 "abbc6a0565122b6c402d61743451830b4faee6ece454601c5711e1c1b4238791"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa03e888c8eff093815be8b459671194c292af6bfbc247210c42aed349b142f5" => :mojave
    sha256 "fa03e888c8eff093815be8b459671194c292af6bfbc247210c42aed349b142f5" => :high_sierra
    sha256 "bed85536ebfec14b98b056e874d116527f154eff2b77024aee52fc407d66791f" => :sierra
  end

  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
