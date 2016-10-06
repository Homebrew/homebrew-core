class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://downloads.sourceforge.net/project/darkice/darkice/1.3/darkice-1.3.tar.gz"
  sha256 "2c0d0faaa627c0273b2ce8b38775a73ef97e34ef866862a398f660ad8f6e9de6"

  bottle do
    cellar :any
    sha256 "a6844ad7e446418f18a1b70af98b4b4ad59df4827fba5993b85f5f2d579785be" => :sierra
    sha256 "201cd48e8f01f0eb2a8a9fd80979d0191489a5c6ffc59fbcfab52ca49fa6e3aa" => :el_capitan
    sha256 "b91021c170150894d2ed7afe2a8a9a624ce50b829904e8a0da9c7aba03beaba6" => :yosemite
    sha256 "fdd61629382c701b120da374a909385be2a1240df6490b85d9fd103e5d10d07f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "lame"
  depends_on "two-lame"
  depends_on "faac"
  depends_on "libsamplerate"
  depends_on "jack"

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
