class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.tar.gz"
  sha256 "e843df002fcea2a90609d87e4d6c28f8a0e23332d3b42979ab1793e18f839307"
  revision 1

  bottle do
    cellar :any
    sha256 "747d8a98e45ed2d48b9b33c2246fcd2de7f7ef94766d82d87bceb6a591d28a8a" => :catalina
    sha256 "b53926f1e2a9ec5edd61f43790f607f458d0760288a7df1719d438f920e81a66" => :mojave
    sha256 "d1a273c51ed07deed7be74921f45875fb1debeea209500b1eb4031acc6fe0795" => :high_sierra
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.3.tar.gz"
    sha256 "37b7886a23cfbde472715ba1266e1a81e2a87c3f5ccce8ae23bd7b38bacdcec2"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
