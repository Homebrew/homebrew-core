class Kes < Formula
  desc "Fork of the es shell based on the rc command interpreter"
  homepage "https://github.com/epilnivek/kes"
  url "https://github.com/epilnivek/kes/archive/v0.9.tar.gz"
  sha256 "d0db16ba7892d9692cacd552d684f03a9d0333ba0e7b629a998fa9c127ef050e"
  revision 1

  head "https://github.com/epilnivek/kes.git"

  bottle do
    cellar :any
    sha256 "f5e4439f7bcdd3f86df61f83c0e186fe916cb69c39dd1ad36e6086ab89d1016a" => :sierra
    sha256 "d97ae9006c6669d0fbd2b5df363b4014f90f436419b4a432cf8166b65903dfd1" => :el_capitan
    sha256 "833b3f0ebb8c1dcd8f0efefa76f04a1938964bb40c5c30081108b565f1a0e066" => :yosemite
  end

  depends_on "readline"

  conflicts_with "es", :because => "both install 'es' binary"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-readline"

    bin.mkpath
    man1.mkpath

    system "make", "install"
  end

  test do
    assert_equal "Homebrew\n", shell_output("#{bin}/es -c 'echo Homebrew'")
  end
end
