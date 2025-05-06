class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.5.4.zip"
  sha256 "0f397a10402b9710e1c6a9db2b77a922a8d399a51efa6e7bffba73e3bbe5ba48"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df665899139ebb624be6d695e0c8b4799fcb51bd94edc0d42a7601715b4a8d4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df665899139ebb624be6d695e0c8b4799fcb51bd94edc0d42a7601715b4a8d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df665899139ebb624be6d695e0c8b4799fcb51bd94edc0d42a7601715b4a8d4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecc32fd4e5b99acd02277ba09180409c4d8d910e5553f4cbf6261bf01bc0d3ee"
    sha256 cellar: :any_skip_relocation, ventura:       "ecc32fd4e5b99acd02277ba09180409c4d8d910e5553f4cbf6261bf01bc0d3ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df665899139ebb624be6d695e0c8b4799fcb51bd94edc0d42a7601715b4a8d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df665899139ebb624be6d695e0c8b4799fcb51bd94edc0d42a7601715b4a8d4e"
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
