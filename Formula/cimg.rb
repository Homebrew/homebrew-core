class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_1.7.9.zip"
  sha256 "fa7800d420807e367c0f77e6d5076decba55dc51c9319f9e9e5cf822ac0ce81d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a682bf144d609aeb8c185839226ded8fccc08e7f13fe63ec6399928105f8fb6" => :sierra
    sha256 "99a4424e348cc18c366a58137ad22e1d9fbe5de88afce72e32dea13fe64aa7ac" => :el_capitan
    sha256 "99a4424e348cc18c366a58137ad22e1d9fbe5de88afce72e32dea13fe64aa7ac" => :yosemite
  end

  def install
    include.install "CImg.h"

    doc.install %w[
      README.txt
      Licence_CeCILL-C_V1-en.txt
      Licence_CeCILL_V2-en.txt
      examples
      plugins
    ]
  end

  test do
    cp_r doc/"examples", testpath
    cp_r doc/"plugins", testpath
    system "make", "-C", "examples", "mmacosx"
    system "examples/image2ascii"
  end
end
