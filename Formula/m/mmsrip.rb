class Mmsrip < Formula
  desc "Client for the MMS:// protocol"
  homepage "https://nbenoit.tuxfamily.org/index.php?page=MMSRIP"
  url "https://nbenoit.tuxfamily.org/projects/mmsrip/mmsrip-0.7.0.tar.gz"
  sha256 "5aed3cf17bfe50e2628561b46e12aec3644cfbbb242d738078e8b8fce6c23ed6"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?mmsrip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd7b148f1a0c9017f7a141493d40fd0c4e764fe34a458f151ccb5925bcbc2a13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c834ca9c19e7b5bc37a0895b146f99d6075760948468a2c8b1bbd4cc67191c2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5d47cddeabd5f3cbd7b0c2c988d10dee8726dcf557f95eb3cada3a1cdc954a7"
    sha256 cellar: :any_skip_relocation, ventura:        "6b305d9a6f6fc639792dfc7cfa1253c060132ad799eadd64878e87a688029b7f"
    sha256 cellar: :any_skip_relocation, monterey:       "7c87f0f2f82134a872ac528a24c8c66231ee101d6611e85c4cf9dc346a34fcda"
    sha256 cellar: :any_skip_relocation, big_sur:        "74c94f8562cc8c71a8376fc3a294a05a78c2a520ee7cb38a4996577d8417a06f"
    sha256 cellar: :any_skip_relocation, catalina:       "084dec614496303468f92768c1f262f3a72abf9b839791e84711ed9288efb402"
    sha256 cellar: :any_skip_relocation, mojave:         "1cff3346265ccfa27553e90225de862c7a1ac61ff54c8fdb8fabfc4204d1bad3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e7c12a6c8e6ef612d1c789fad3e06c0b21acfe6e4dbac1643ae7797faeafcb35"
    sha256 cellar: :any_skip_relocation, sierra:         "b4578327661828737b3aa71615806ba6e2781d7c0815a12815023242ac80e598"
    sha256 cellar: :any_skip_relocation, el_capitan:     "cf0bc6b407f4861b174eddf55ae5da45330d37abc428013ca19f173d36a96d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3d2396067956a932acbac5b815338b0e46e05ffa157dc20833725f01af8630"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmsrip --version 2>&1")
  end
end
