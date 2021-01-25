class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.8.tar.gz"
  sha256 "985c3fadb9789d2815e50f4ff714511c79c2710ac27a4aaaf5c0c2662141426d"

  livecheck do
    url :stable
    regex(%r{url=.*?/faad2[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "512c0a82b5d332c0558cf27a210ee0cabed163ae8a057d9a13bffe934b6bbd9b" => :big_sur
    sha256 "9d15e44991762f7fe0b3ec9a41cf76ebe2ba6ed0f5ff2b2c5a10916214cc7e27" => :arm64_big_sur
    sha256 "f12e1d6b2b8bb7e49bbb681711c5da2a45ad7d3957c72105ab6b13c194d9e33d" => :catalina
    sha256 "a896f898d36455dbb65b19efcc1f574be76c22dca981e3361be08ef234fd6e5d" => :mojave
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
