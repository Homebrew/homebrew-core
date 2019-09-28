class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.5.1.tar.gz"
  sha256 "5b1026f18b8274be869245ed63427bf8ddac0739c67be12c4a769ac948824eeb"
  head "git://git.chiark.greenend.org.uk/~ianmdlvl/adns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b64b05711e87f1c4e55cf029ff08df01b49614760063971d3ba027ad8c7a8f2" => :catalina
    sha256 "1a067d7acebfc1733c3b035ca51c7bbf73fa5af96072447933c77025b66af897" => :mojave
    sha256 "5abc21fa69037e1a161c90a594077c6fc8b74aed19f371337aa4a4946e9cc08f" => :high_sierra
    sha256 "3bbd0cc0bc05c228746629760bcd027bbe90aa54e3b79fc2d4553e7fd5900d44" => :sierra
    sha256 "90fd1e0e102f446de1e647f2c3ec9f0dd6c5df190dcbdd9f1136bb90e344d730" => :el_capitan
    sha256 "9c5974b93f921e8d6c735ca6722d83d94d5a501d301d337177741f4a2a8f9128" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/adnsheloex", "--version"
  end
end
