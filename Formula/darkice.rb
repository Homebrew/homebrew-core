class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/releases/download/v1.4/darkice-1.4.tar.gz"
  sha256 "e6a8ec2b447cf5b4ffaf9b62700502b6bdacebf00b476f4e9bf9f9fe1e3dd817"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "c312949cef4bec0b37951d4e9f3b9211a0a0c04d8666cb14bfde0a9f6c85ad5e" => :catalina
    sha256 "b41dd758dcda3daa8bcde6c5f161fb73d9268bef1bd68940e320fe0374b8272e" => :mojave
    sha256 "a8b0c02c6b00f614c9eac9d05fa17aee233021879edf7abc8cd81d1de34881e4" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "jack"
  depends_on "lame"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "two-lame"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-lame-prefix=#{Formula["lame"].opt_prefix}",
                          "--with-faac-prefix=#{Formula["faac"].opt_prefix}",
                          "--with-twolame",
                          "--with-jack",
                          "--with-vorbis",
                          "--with-samplerate"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darkice -h", 1)
  end
end
