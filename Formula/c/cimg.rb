class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.5.0.zip"
  sha256 "6126e66e44b447748fb8cd97246707ac90b598e36ca1575e58104b03aa834c62"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a8bda491f815b8b397fd314a42e73fccf4ba33a88bbe0f40650166632d6890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a8bda491f815b8b397fd314a42e73fccf4ba33a88bbe0f40650166632d6890"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5a8bda491f815b8b397fd314a42e73fccf4ba33a88bbe0f40650166632d6890"
    sha256 cellar: :any_skip_relocation, sonoma:        "698fbcbf0794dfbd76b3932a0af7b5eeb3fa35cdc08035ab5680907a586d3c7e"
    sha256 cellar: :any_skip_relocation, ventura:       "698fbcbf0794dfbd76b3932a0af7b5eeb3fa35cdc08035ab5680907a586d3c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5a8bda491f815b8b397fd314a42e73fccf4ba33a88bbe0f40650166632d6890"
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
