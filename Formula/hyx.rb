class Hyx < Formula
  desc "Powerful hex editor for the console"
  homepage "https://yx7.cc/code/"
  url "https://yx7.cc/code/hyx/hyx-2021.06.09.tar.xz"
  sha256 "8d4f14e58584d6cc8f04e43ca38042eed218882a389249c20b086730256da5eb"
  license "MIT"

  def install
    inreplace "Makefile", " -Wl,-s", " "
    inreplace "Makefile", " -Wl,-z,relro,-z,now -fpic -pie", " "
    inreplace "Makefile", " -Werror", " "

    system "make"

    bin.install "hyx"
    doc.install "license.txt"
  end

  test do
    assert_match "This is hyx", shell_output("#{bin}/hyx -v").chomp
  end
end
