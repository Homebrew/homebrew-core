class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "http://nfdump.sourceforge.net"
  url "https://github.com/phaag/nfdump/archive/v1.6.15.tar.gz"
  sha256 "9505c0511d273b9aa3f87a5e664425689a3c7370c6ae3bbc05ff4bdb41bfd457"

  bottle do
    cellar :any
    sha256 "db9e670884d81edc39a3d6525d816e1260c25a3d80139a5909cabe6cbd12c387" => :sierra
    sha256 "ab1c65e136ed09f0fbe3abbc225e50f21f26bb890726cde8d77458061d55a8de" => :el_capitan
    sha256 "bb20de7ab419cf0834e933b882e5de304aa904c195eec9bdcab8d9549b51dcc3" => :yosemite
    sha256 "684c713ad51c8394df5c8dd3d834eea96600bda373b1e6123db284d55bfc7709" => :mavericks
  end

  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    # https://github.com/phaag/nfdump/issues/32
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system bin/"nfdump", "-Z 'host 8.8.8.8'"
  end
end
