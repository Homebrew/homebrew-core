class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.6.0.tar.xz"
  sha256 "0706e101a6e0e806335aeb57445e2f6beffe0be29a761f561979e81691c2c681"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "6786313633e6b08f00a5f79c6391505f670d30e52d5836c2b1ae2eede5186816" => :big_sur
    sha256 "6fe6e0fdec64f42b17c5754154caeb5c352389d2d26c23d8a21910a727c54841" => :arm64_big_sur
    sha256 "040dab4ba89bdd45f5fc1429fd40f4952b0b1b1365e7143f0a8f2fab9f14d60f" => :catalina
    sha256 "d102685671b1816d8c7b79e530d960778dc58655593721e0fdcd69a99b29fed1" => :mojave
    sha256 "f75d4bbd7bfe8caaec6b386b8217c70ee432c17d7dd9ebf42ae04c0c58a88ca2" => :high_sierra
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
