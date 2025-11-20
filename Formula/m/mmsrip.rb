class Mmsrip < Formula
  desc "Client for the MMS:// protocol"
  homepage "https://web.archive.org/web/20241016171436/https://nbenoit.tuxfamily.org/index.php?page=MMSRIP"
  url "https://web.archive.org/web/20161207201859/https://nbenoit.tuxfamily.org/projects/mmsrip/mmsrip-0.7.0.tar.gz"
  sha256 "5aed3cf17bfe50e2628561b46e12aec3644cfbbb242d738078e8b8fce6c23ed6"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5216ece2171a711b50b797f04f7fea905f9e0cdd580d8c3d98df8619573060b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ba19c7e871dd33876bdbd931af577e633a3c2eeb1f0fb25c9d3ade606a0b8c1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55daa14e690e02d12277a19443906bfbf3fa4bd20a4415a8cc362fa954eead44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd7b148f1a0c9017f7a141493d40fd0c4e764fe34a458f151ccb5925bcbc2a13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c834ca9c19e7b5bc37a0895b146f99d6075760948468a2c8b1bbd4cc67191c2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5d47cddeabd5f3cbd7b0c2c988d10dee8726dcf557f95eb3cada3a1cdc954a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4665219513e38fb8be8e5f53688720cc572721bbdefc2e6be1b03830ecd8bb1b"
    sha256 cellar: :any_skip_relocation, ventura:        "6b305d9a6f6fc639792dfc7cfa1253c060132ad799eadd64878e87a688029b7f"
    sha256 cellar: :any_skip_relocation, monterey:       "7c87f0f2f82134a872ac528a24c8c66231ee101d6611e85c4cf9dc346a34fcda"
    sha256 cellar: :any_skip_relocation, big_sur:        "74c94f8562cc8c71a8376fc3a294a05a78c2a520ee7cb38a4996577d8417a06f"
    sha256 cellar: :any_skip_relocation, catalina:       "084dec614496303468f92768c1f262f3a72abf9b839791e84711ed9288efb402"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "49d856f20c968fe3c8b2272f07903d47aec7ecb6aa4723cb51dbbae79ea0fd35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3d2396067956a932acbac5b815338b0e46e05ffa157dc20833725f01af8630"
  end

  # Deprecation reasons:
  # * TuxFamily URLs are no longer available (https://forum.tuxfamily.org/topic/775/is-tuxfamily-slowly-dying/)
  # * Analytics on deprecation date were "0 (30 days), 0 (90 days), 5 (365 days)"
  # * Last release in 2006
  # * The MMS protocol was deprecated in 2003
  deprecate! date: "2025-03-17", because: :unmaintained

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
