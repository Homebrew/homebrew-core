class Pioneers < Formula
  desc "Settlers of Catan clone"
  homepage "https://pio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pio/Source/pioneers-15.4.tar.gz"
  sha256 "9a0d3198dc0ddf131d9e6d6e9992347fe2a2d99f508f1be1b30c5797210a2ddc"

  bottle do
    sha256 "7077d041a45570cd020338a7aeeca2804675d993ae46db6d0f3364c41840f8ab" => :high_sierra
    sha256 "ab5a8f58765f5121b134507c3c12e0f4f6c0bf26a5ccddb1ad07f3b8046831f0" => :sierra
    sha256 "125fda4a203f876a2e58f46986e778989d7b8edfaed38069a6dea2d8f11ea4f7" => :el_capitan
    sha256 "4dcd7c97726388e3175cfbf9bfe9aee17deb7d5894d7a864bdcf2b9295b7b0ed" => :yosemite
  end

  fails_with :clang do
    build 318
    cause "'#line directive requires a positive integer' argument in generated file"
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "librsvg" # svg images for gdk-pixbuf

  def install
    # fix usage of echo options not supported by sh
    inreplace "Makefile.in", /\becho/, "/bin/echo"

    # GNU ld-only options
    inreplace Dir["configure{,.ac}"] do |s|
      s.gsub!(/ -Wl\,--as-needed/, "")
      s.gsub!(/ -Wl,-z,(relro|now)/, "")
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pioneers-editor", "--help"
    server = fork do
      system "#{bin}/pioneers-server-console"
    end
    sleep 5
    Process.kill("TERM", server)
  end
end
