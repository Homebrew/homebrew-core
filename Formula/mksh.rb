class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R59.tgz"
  sha256 "592a28ba67bea8a285f003d7a5d21b65e718546c8fcb375d7d696f3d5dd390ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b85206a01c3305020f2cfc49fdabf071c8f95ad9afbbe5cf05c4666aabd50ed" => :catalina
    sha256 "12dfdb2d357a00d2fcd8b36f15e6b49c5935f5f38ed8d1aac98318df102da353" => :mojave
    sha256 "f06b7c34f7a3e2bf5c363b95fbede1e68bffb1c72519e91c16fa55151e2aba8c" => :high_sierra
  end

  def install
    system "sh", "./Build.sh", "-r"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  test do
    assert_equal "honk",
      shell_output("#{bin}/mksh -c 'echo honk'").chomp
  end
end
