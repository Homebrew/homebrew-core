class Mussh < Formula
  desc "Multi-host SSH wrapper"
  homepage "https://mussh.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mussh/mussh/1.0/mussh-1.0.tgz"
  sha256 "6ba883cfaacc3f54c2643e8790556ff7b17da73c9e0d4e18346a51791fedd267"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07337c6b9c07eccfc53f140d58340ca8b2b75a81d374023c4f0218544e21ad5a"
  end

  def install
    bin.install "mussh"
    man1.install "mussh.1"
  end

  test do
    system "#{bin}/mussh", "--help"
  end
end
