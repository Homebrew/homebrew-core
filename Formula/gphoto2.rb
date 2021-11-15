class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.27/gphoto2-2.5.27.tar.bz2"
  sha256 "30054e93a1bb59f501aabd5018713177ea04ce0cb28935319bd6ca80061e8d38"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "aed8f136de4af929a10eb71ae2b4d42cc57b0efab09349abd5cedf53189bb278"
    sha256 cellar: :any, arm64_big_sur:  "74dd60846e5b2a27cb13a10bd1a51e69dc4a69f8f507b846e814acdbea258e35"
    sha256 cellar: :any, monterey:       "7c48db0ac3bf828fb201e03b1ba58b9aa5c4fd5006492ffa05eafc69648287c9"
    sha256 cellar: :any, big_sur:        "9c9b7500633f88d5d2301c8dd3dcc92941fcd7ec42ae09859f59a79d2c3b4061"
    sha256 cellar: :any, catalina:       "4f441bdceb481a8b91c29bff4e1bc559ea960b9b39e07d6253576b8c90590329"
    sha256 cellar: :any, mojave:         "cfb60930c36f3083c3913f07acb47ce2ebd3214e25ca6901862f9e6666e8d7cc"
    sha256               x86_64_linux:   "3373ff2ef86c42f624ae10db3e34cc57678484d9e0210dc38a8713cdd135927f"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
