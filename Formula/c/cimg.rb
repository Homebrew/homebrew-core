class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.5.2.zip"
  sha256 "3397b9c84d66e63b46ebad41e52932605bab2979fc513484bcde6df923bd9a20"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cc321629f6b4eb79c45a84097875ad2c6ba8a7f1a4d57a015804b80c7d95db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cc321629f6b4eb79c45a84097875ad2c6ba8a7f1a4d57a015804b80c7d95db8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cc321629f6b4eb79c45a84097875ad2c6ba8a7f1a4d57a015804b80c7d95db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4b296a0ea2c9ce126088c9b3349fc1e488ddfe9cfcba5d2438ae4a5dd0189cc"
    sha256 cellar: :any_skip_relocation, ventura:       "a4b296a0ea2c9ce126088c9b3349fc1e488ddfe9cfcba5d2438ae4a5dd0189cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cc321629f6b4eb79c45a84097875ad2c6ba8a7f1a4d57a015804b80c7d95db8"
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
