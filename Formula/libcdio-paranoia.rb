require "English"

class LibcdioParanoia < Formula
  desc "Audio CD ripper based on libcdio"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz"
  sha256 "d60f82ece97eeb92407a9ee03f3499c8983206672c28ae5e4e22179063c81941"

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    system "./configure", "--without-versioned-libs",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /cdparanoia/, shell_output("#{bin}/cd-paranoia -V 2>&1", 0).partition(" ").first
    system("#{bin}/cd-paranoia", "-V")
    assert_equal $CHILD_STATUS, true, "Execution of cd-paranoia failed."
  end
end
