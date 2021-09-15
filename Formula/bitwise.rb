class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.42/bitwise-v0.42.tar.gz"
  sha256 "d3d43cef47bf8f49e85f7ed381c3eaf1df921ca51805e0962f1a97a517e1d1d2"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4301045752db45352b2f1554ae015a8263e77dea15d724aeb0d8a7bb3b78f1db"
    sha256 cellar: :any,                 big_sur:       "ee1f6edfdc4b538a0017253af270a94fc28da00bdac5754efcef42ed8718e1dc"
    sha256 cellar: :any,                 catalina:      "0f6da9c52d7e2185dc61708d5bdda296708d4bd398c525e01a699eaf58feac21"
    sha256 cellar: :any,                 mojave:        "9844d7c02e06929bd6060454f93ccb115186f1f3418c3d4f1a93f2a0764ec0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962189cb81bb6f94faa36609171829fed77481e21119fc93ee3e94bde82493bc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match "0 0 1 0 1 0 0 1", shell_output("#{bin}/bitwise --no-color '0x29A >> 4'")
  end
end
