class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.43/bitwise-v0.43.tar.gz"
  sha256 "f524f794188a10defc4df673d8cf0b3739f93e58e93aff0cdb8a99fbdcca2ffb"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65415084e611bb674c85a509a489f3efb62f8cbb13fc729c2375d30b4f4e9625"
    sha256 cellar: :any,                 arm64_monterey: "37d182e71950518aa30bda7d31e838b064bf3fdca49bb19946529b848deae93f"
    sha256 cellar: :any,                 arm64_big_sur:  "b9e69835e64543d6f75709169ea716772f14d5122ceb197228afb40162400769"
    sha256 cellar: :any,                 ventura:        "541cbdb46f824065566281d18a3269aa5e2498cf1f5a3e0973d4e3e22824fdae"
    sha256 cellar: :any,                 monterey:       "8788e244c3c623f42c3b5179bdc88b383c4a7bc0a660c8f228e41f5a1682c6e0"
    sha256 cellar: :any,                 big_sur:        "06b2465c3a088959dde713f12a1541f20bfdadee29fc4b52348f8a858ca5c95e"
    sha256 cellar: :any,                 catalina:       "96e4fbec05bf5d3db74039155aa0f58cc9ef5b9f531c3794149e7a4151d5ef60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14b52e107bbb7d3bf3c6fbfff7ce838c50e41c6d3721a3c65e413cc89ccd231c"
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
