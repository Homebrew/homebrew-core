class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.17/libmtp-1.1.17.tar.gz"
  sha256 "f8a34cf52d9f9b9cb8c7f26b12da347d4af7eb904c13189602e4c6b62d1a79dc"

  bottle do
    cellar :any
    sha256 "47ef836719d1fc0ddfc64528d93f1892a4b1db55cc73b025d5824a53956b8ff6" => :catalina
    sha256 "dab56fa876053034299e6a5e6ccdc56d8f55b2b6eba89cb7fc402d011f3e5318" => :mojave
    sha256 "89264c49b080c39b588ffa5f4ecad60aaa68aca5baf92a6460defee779c4733e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
