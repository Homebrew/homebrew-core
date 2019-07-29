class Hesiod < Formula
  desc "Library for the simple string lookup service built on top of DNS"
  homepage "https://github.com/achernya/hesiod"
  url "https://github.com/achernya/hesiod/archive/hesiod-3.2.1.tar.gz"
  sha256 "813ccb091ad15d516a323bb8c7693597eec2ef616f36b73a8db78ff0b856ad63"
  revision 1

  bottle do
    sha256 "4b2e392609aad28f223135fe351688d9b104517ba7574f0b9166a3159136f56f" => :mojave
    sha256 "7eb0a5a6ef9a8c9ad568ab371ac8186499f7616265a86f8fc3d28c2ed5ce9cfe" => :high_sierra
    sha256 "62ea1a19f382f4b07888c5bd286939e6fe055e6755ae7c702b16867a1854f40d" => :sierra
    sha256 "71c59e1287dd90d1cef092e87f1e05ab408fbd85ca101b6093d1513a4d63ffdc" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libidn"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hesinfo", "sipbtest", "passwd"
    system "#{bin}/hesinfo", "sipbtest", "filsys"
  end
end
