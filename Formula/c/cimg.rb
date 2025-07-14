class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.5.5.zip"
  sha256 "92289c69713f05bd02792c18eefcd1d5abd1cb57f25fb5993d49cd597aa2efa6"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
    sha256 cellar: :any_skip_relocation, sonoma:        "f37630fd09733c60ce21471bd08217aea720309a028910e5130e58b858aa2426"
    sha256 cellar: :any_skip_relocation, ventura:       "f37630fd09733c60ce21471bd08217aea720309a028910e5130e58b858aa2426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
  end

  def install
    include.install "CImg.h"
    prefix.install "Licence_CeCILL-C_V1-en.txt", "Licence_CeCILL_V2-en.txt"
    pkgshare.install "examples", "plugins"
  end

  test do
    cp_r pkgshare/"examples", testpath
    cp_r pkgshare/"plugins", testpath
    cp include/"CImg.h", testpath
    system "make", "-C", "examples", "image2ascii"
    system "examples/image2ascii"
  end
end
