class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.8.tar.gz"
  sha256 "985c3fadb9789d2815e50f4ff714511c79c2710ac27a4aaaf5c0c2662141426d"

  bottle do
    cellar :any
    sha256 "e8872363a2fda9a3c9872ef697e517c638e54e2af5238d9e94b30e34ecdc505e" => :high_sierra
    sha256 "f05989cbd9630fc37c962fc28ff29ec48a5fa7b71fe4ff9e520db6add1d0f09e" => :sierra
    sha256 "94205432c0187c2ccef411b05934b8db57512bd80b53c8f9c00f3792ee478684" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "infile.mp4", shell_output("#{bin}/faad -h", 1)
  end
end
