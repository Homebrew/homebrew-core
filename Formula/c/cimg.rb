class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.5.3.zip"
  sha256 "a9b825366ade0a1cfda784c87b40aa5e65f84f2d5ec562ae48928161880ed01b"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "802f049ec2de8d9e442fff040210ee61a9a7fee12cb5db03aa047f40b3979dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "802f049ec2de8d9e442fff040210ee61a9a7fee12cb5db03aa047f40b3979dc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "802f049ec2de8d9e442fff040210ee61a9a7fee12cb5db03aa047f40b3979dc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc9c5dc3c55049540f22cc19afec3e7f2716b81984ee64a6bdba2e055e812c28"
    sha256 cellar: :any_skip_relocation, ventura:       "dc9c5dc3c55049540f22cc19afec3e7f2716b81984ee64a6bdba2e055e812c28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "802f049ec2de8d9e442fff040210ee61a9a7fee12cb5db03aa047f40b3979dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802f049ec2de8d9e442fff040210ee61a9a7fee12cb5db03aa047f40b3979dc0"
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
