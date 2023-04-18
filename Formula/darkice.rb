class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/releases/download/v1.4/darkice-1.4.tar.gz"
  sha256 "e6a8ec2b447cf5b4ffaf9b62700502b6bdacebf00b476f4e9bf9f9fe1e3dd817"
  license "GPL-3.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "caaafe8dbf56dd3cdda2f846a140a2db35a7536d7796b12a38389b8f60ae13a4"
    sha256 cellar: :any,                 arm64_monterey: "5c818db8d3d5bad23fb9125499e2840ed2d897f089407a18a5e309939986982e"
    sha256 cellar: :any,                 arm64_big_sur:  "3a4f9f7d9203130529868ad9b0ff539bb795c531b4603090d6255441d5b15dbc"
    sha256 cellar: :any,                 ventura:        "a70a91ec300bb7b40820b2cb2b737838633b61a8ccf37008990f02065ea6ffeb"
    sha256 cellar: :any,                 monterey:       "06d6c5a858374cec98f3b0ba736040da5424ca02d31b3417c60afb97b3bd8381"
    sha256 cellar: :any,                 big_sur:        "500b7d4a2ccd852588c4ac9cd65f901817f19961ad21e8c2355b82318efd74d4"
    sha256 cellar: :any,                 catalina:       "c312949cef4bec0b37951d4e9f3b9211a0a0c04d8666cb14bfde0a9f6c85ad5e"
    sha256 cellar: :any,                 mojave:         "b41dd758dcda3daa8bcde6c5f161fb73d9268bef1bd68940e320fe0374b8272e"
    sha256 cellar: :any,                 high_sierra:    "a8b0c02c6b00f614c9eac9d05fa17aee233021879edf7abc8cd81d1de34881e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4618898033a3065666fae661f35c487ff2f6a52b6ac17a86d66d8bcf19eea4"
  end

  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "jack"
  depends_on "lame"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "two-lame"

  def install
    ENV.cxx11
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
