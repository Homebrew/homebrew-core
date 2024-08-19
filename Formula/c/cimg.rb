class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.4.0.zip"
  sha256 "d6b8e2ff696750d85d41eb4e6d692676584dfdf32a078caee18708f88789b6a6"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da0d47b2cbfaefc4b8f87ee053bb8308d6b9375969ef7ab7902a9c62526f761c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da0d47b2cbfaefc4b8f87ee053bb8308d6b9375969ef7ab7902a9c62526f761c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0d47b2cbfaefc4b8f87ee053bb8308d6b9375969ef7ab7902a9c62526f761c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dff1257405256c85c26e39024064c76c621bbc33edefebb617893db023d65e5"
    sha256 cellar: :any_skip_relocation, ventura:        "7dff1257405256c85c26e39024064c76c621bbc33edefebb617893db023d65e5"
    sha256 cellar: :any_skip_relocation, monterey:       "7dff1257405256c85c26e39024064c76c621bbc33edefebb617893db023d65e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da0d47b2cbfaefc4b8f87ee053bb8308d6b9375969ef7ab7902a9c62526f761c"
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
