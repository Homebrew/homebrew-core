class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/releases/download/v1.4/darkice-1.4.tar.gz"
  sha256 "e6a8ec2b447cf5b4ffaf9b62700502b6bdacebf00b476f4e9bf9f9fe1e3dd817"

  bottle do
    cellar :any
    sha256 "11c09659a5e54a2c66ef162946d4103b6c9677cdf4c91ff372448d06819692a9" => :catalina
    sha256 "a35885863f951a6660c82a09158195172df5e8e29b1c02005e8627275a38d080" => :mojave
    sha256 "e07c9c9beafe2a9fae19ae6570181ef838da42755b9d9677535f8410768c1e7e" => :high_sierra
    sha256 "f5acac754cda3888160930ff630d33d5a7f134e455b21ad21a40b41150e12f49" => :sierra
    sha256 "a3a9604162e1dd71c1ec69cfec895e0a92329e57f478a01131a2a00a3c495544" => :el_capitan
    sha256 "64c3ebd7486589b3e9a216a4be8158ad94b1ceafac15934f97b4b3f3d684ad05" => :yosemite
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
