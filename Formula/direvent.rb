class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "https://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftp.gnu.org/gnu/direvent/direvent-5.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/direvent/direvent-5.2.tar.gz"
  sha256 "239822cdda9ecbbbc41a69181b34505b2d3badd4df5367e765a0ceb002883b55"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9879af22d0f9bba86a36cb76f7497377da85b061115615d500445be7741f24d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd7a995c95981503fc5a216a1d3f1b2cfdb958526eafca3e3b1dba96440cf35e"
    sha256 cellar: :any_skip_relocation, monterey:       "ad88fdf4358aa70d211093ee263997ed413d5de2ec3994e0c2c0414ad61a6fdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "546c0a2add166633414dfc859731b0db475ffab1cd936ef7549e2694e6d2380f"
    sha256 cellar: :any_skip_relocation, catalina:       "5aa186d6c50f9865450430bd7641c2be32380ab3eaa3f67e8fe4803cd2139b8d"
    sha256 cellar: :any_skip_relocation, mojave:         "0e9d14d7340a3031305913d1a506f17ebedfaae4b6da0c340d23f754de3fc4c7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b1893330b8cd3c41bfcfb1a5a919bf887febf17b9e5067d428d31169c8218295"
    sha256 cellar: :any_skip_relocation, sierra:         "6b04f666ccddc5f843e2dae19ee9af577390e9f1642b284237e5055885fb9864"
    sha256                               x86_64_linux:   "5dd894c0cc5a514754ed7481a310c5eb9631a4d73509009dbcbeb92e4e4b86e1"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end
