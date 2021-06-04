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
    sha256 cellar: :any, arm64_big_sur: "da7d3ed292b63f22c33d46bf1b029c7eae4b1dcd1ed70dac7d6ea283159e919b"
    sha256 cellar: :any, big_sur:       "ace4589475844621942acda0985939f6c47e186aae7a223d69bbe518f2f86c7b"
    sha256 cellar: :any, catalina:      "f2318ad62d9921d5ae1dfd2c1625102145f873ce8d0b5f6d3edcde7875fcaf1d"
    sha256 cellar: :any, mojave:        "9e9615a1c143088bed4f8ae1b3bf0d0b2e9ddf3a5b9f69bf968313df4e0aaf4d"
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
