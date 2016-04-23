class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "http://www.nongnu.org/pngpp/"
  url "https://savannah.nongnu.org/download/pngpp/png++-0.2.9.tar.gz"
  sha256 "abbc6a0565122b6c402d61743451830b4faee6ece454601c5711e1c1b4238791"
  head "svn://svn.savannah.nongnu.org/pngpp/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b01b3ff0af9e60f2887bb45ff5ba2f5823a9a440c2d78e51e69904d3edd80d8" => :el_capitan
    sha256 "de37d7fadb7308b45ba0448308256d00bf36442bacbab1e734ee8398aea8a8dd" => :yosemite
    sha256 "f2e242ee428f191645418a9897eb2fd729408dd67d04e7af4cefc7dcb5715250" => :mavericks
  end

  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
