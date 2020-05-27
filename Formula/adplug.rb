class Adplug < Formula
  desc "Free, hardware independent AdLib sound player library"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplug/releases/download/adplug-2.3.2/adplug-2.3.2.tar.bz2"
  sha256 "6faa232e0b3107019fa3c752756658e0aa1d5c5555a7c9be7fe73652d12d57df"

  bottle do
    cellar :any
    sha256 "6ac5b7980cf8df57606877fddef2c04344284a45846397d3772fa2d37f61e05a" => :catalina
    sha256 "d38c5773152237b8e3132313098a405ba13370c11a16851ecd25f6c26ed66e9e" => :mojave
    sha256 "5a78ae0d931b6cb8e5a55caa2430728bf241dc69d4cdcb00ea989b292ba526cf" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libbinio"

  resource "ksms" do
    url "http://advsys.net/ken/ksmsongs.zip"
    sha256 "2af9bfc390f545bc7f51b834e46eb0b989833b11058e812200d485a5591c5877"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("ksms").stage do
      mkdir "#{testpath}/.adplug"
      system "#{bin}/adplugdb", "-v", "add", "JAZZSONG.KSM"
    end
  end
end
