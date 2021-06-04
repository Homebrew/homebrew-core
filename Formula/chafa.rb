class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.6.1.tar.xz"
  sha256 "76c98930e99b3e5fadb986148b99d65636e9e9619124e568ff13d364ede89fa5"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5b9d9896282474c7835a356d4be5b1affa9e674ce741d83001062dbd7928de1e"
    sha256 cellar: :any, big_sur:       "4033db8327ba1738f613f7892bb086a960f5c0239fed8a203ff18600548f98ae"
    sha256 cellar: :any, catalina:      "cd05130e3b8679f1d31f1f64c8bb56103aca6545b44a2964a32d4b474b2fcf5e"
    sha256 cellar: :any, mojave:        "efcc8ce344097a5e19db9129d7c30cd2852a74d5033eaf3bfcab62d4d7470d62"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "imagemagick"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 4, output.lines.count
  end
end
