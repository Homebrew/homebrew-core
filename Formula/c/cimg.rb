class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.4.3.zip"
  sha256 "60a73922f2c6bb5b570eeda511aed029b3c9f3d7a3295ecb10fad14e41373e91"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53c866c9ec6c066c5905bf7b732f70a6ecfa42b4490194563ad54f482db6d54a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53c866c9ec6c066c5905bf7b732f70a6ecfa42b4490194563ad54f482db6d54a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53c866c9ec6c066c5905bf7b732f70a6ecfa42b4490194563ad54f482db6d54a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcc4c691303eceb583195ad83b228b4d39a1da5e6d42eb6acd98e22b3e16a739"
    sha256 cellar: :any_skip_relocation, ventura:       "dcc4c691303eceb583195ad83b228b4d39a1da5e6d42eb6acd98e22b3e16a739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c866c9ec6c066c5905bf7b732f70a6ecfa42b4490194563ad54f482db6d54a"
  end

  fails_with gcc: "5" # C++ 17 is required

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
