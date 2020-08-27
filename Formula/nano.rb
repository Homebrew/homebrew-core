class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.2.tar.xz"
  sha256 "32c2da43e1ae9a5e43437d8c6e1ec0388af870c7762c479e5bffb5f292bda7e1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "7ec2ac2d56019cbc9c41db0e2bb30db192d2c286545b3e6ae6257a6c07e491e7" => :catalina
    sha256 "e67eb4b70a17baa9430b3811c0a69d6246a652553d83e2c80b37bda154d6cdfb" => :mojave
    sha256 "6f70b0d956076fff6bc2daff41dfde0b843f1932b289a457303adf7b2362107b" => :high_sierra
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
