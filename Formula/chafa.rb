class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.4.1.tar.xz"
  sha256 "46d34034f4c96d120e0639f87a26590427cc29e95fe5489e903a48ec96402ba3"

  bottle do
    cellar :any
    sha256 "f8285220cba2737c58bea611f3c0b653b3c5e1306b8cef3ff33642ed26260fb8" => :catalina
    sha256 "a483480366443ac91c52ebab6a06d0995a541098ce163a03c6cef71c0829be1c" => :mojave
    sha256 "272891299f7962a49755de583274a21a49759e020418586fa0e7cdfe7c8e2202" => :high_sierra
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
