class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.9.3.tar.xz"
  sha256 "6e3438f033a0ed07d3d74c30d0803cbda3d2366ba1601b7bbf9b16ac371f51b4"

  bottle do
    sha256 "199872e5dbe7229dc98f1a4bf2c51a72b37289ba226618a49d065b8c15f4f90c" => :catalina
    sha256 "7714d03eed965ed869fefb0140ae7c6accc423664643b85c6abb9e88498af9ca" => :mojave
    sha256 "d1e31bd078e9d26b892e7431b4bc1f66e5b297eef8eae8651d25a783563d5363" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
