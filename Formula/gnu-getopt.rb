class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.xz"
  sha256 "86e6707a379c7ff5489c218cfaf1e3464b0b95acf7817db0bc5f179e356a67b2"

  bottle do
    sha256 "e905a353b1ef1688e569ee28f5caa35bbfa6a4b99f044e255087d0a8adbe092a" => :mojave
    sha256 "5dc8b07eb3425e5b57d7deb4dea187fc992ef358c9c053d3a2dc230d748b4252" => :high_sierra
    sha256 "05391b0dd0876ead74b18a4c5bb9c7db996586bf6918bd014db534027fd9ae2a" => :sierra
    sha256 "5e9e87fe18c5681e80f1cf940fed275ed895831304326bc5e7be6fb6e53e8594" => :el_capitan
    sha256 "f8dbbec03aaaeb1bc774d9bf606701901cc9a8ad15cecc5473567e51845057e6" => :yosemite
    sha256 "27938c615808c8e4ff2eacac0a4059c76dee5518a5c8bbfb304b24b70736b429" => :mavericks
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
