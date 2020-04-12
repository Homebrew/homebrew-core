class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://research.wand.net.nz/software/libflowmanager.php"
  url "https://research.wand.net.nz/software/libflowmanager/libflowmanager-3.0.0.tar.gz"
  sha256 "0866adfcdc223426ba17d6133a657d94928b4f8e12392533a27387b982178373"
  revision 1

  bottle do
    cellar :any
    sha256 "00482390deb850174ce9c6802c5fce4fa4115083f106d5db97472e34d1e611e0" => :catalina
    sha256 "f8149c2a5a868f41d28b7f09b370ad99fc918759d621d6b4a7ecc07d8762bc1d" => :mojave
    sha256 "46e72fe5aed2637f83436f098c2c6e3b375cd3fbf0c6d94ce0658d40aed30969" => :high_sierra
  end

  depends_on "libtrace"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
