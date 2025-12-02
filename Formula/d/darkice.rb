class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/releases/download/v1.5/darkice-1.5.tar.gz"
  sha256 "18b4c4573a7ccfe09c1094eb5798159e2a9892106ea62d753933f6f2a746058e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "164c7248bbc46a4a79b4156816e541a874247a98fb95d7d43759182022983c0d"
    sha256 cellar: :any,                 arm64_sequoia:  "63d77f3484a28636bd7c5a7a804a0d8e3e410e3b07b4859d27ce0a8b9b714233"
    sha256 cellar: :any,                 arm64_sonoma:   "089a73da66e99a1289c3259dc974acf0ffcc053af05facf3b760f8b0d7c4b0e9"
    sha256 cellar: :any,                 arm64_ventura:  "22abd05d4b3d880d9b1ad6abaf636f7d31c65ff3d20a7ce54c888d5464b32369"
    sha256 cellar: :any,                 arm64_monterey: "d70aab113619347c2b1ab5dc69b265a0dcacab27c30a81ad852c12417960e670"
    sha256 cellar: :any,                 sonoma:         "01555e1eff33f033c509891563900a3bd69bbaa658570d298e40f5ed6438a0eb"
    sha256 cellar: :any,                 ventura:        "f922c9ca8895e789a65b11fdabda217f1301d91ce1c19890de8e433a19f8c5f8"
    sha256 cellar: :any,                 monterey:       "47f4bafaa04a5c4eb24783771215f643bf032dbd911145812b3b27d8d3034b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "95f5d5e05e922c398d1f8277465fe2d1350cf7f330d1aa7228026a52a674397d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e96398becc4f8c42c2fa104ea86e96207756ee073a301d0acb0fe56fd665ebcb"
  end

  depends_on "pkgconf" => :build

  depends_on "faac"
  depends_on "jack"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "two-lame"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.cxx11
    system "./configure", "--sysconfdir=#{etc}",
                          "--with-lame-prefix=#{Formula["lame"].opt_prefix}",
                          "--with-faac-prefix=#{Formula["faac"].opt_prefix}",
                          "--with-twolame",
                          "--with-jack",
                          "--with-vorbis",
                          "--with-samplerate",
                          "--without-opus",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darkice -h", 1)
  end
end
