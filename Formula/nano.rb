class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.3.tar.gz"
  sha256 "f12058ead9955cb841c1c5e3b9aec6ba93114a807580e928de0eaf6144c91074"

  bottle do
    sha256 "09a16f42318317a39f08350a1e07240067c5268a3ad3046a0aafc0c922d43a36" => :high_sierra
    sha256 "2934a705b8ba1c7562009dd8386021168e37d9446332c9922340c847a0b57b74" => :sierra
    sha256 "b9aadb66addd1b7b611a45523b87fa0b9606be044988bbb09a1c9887c84b4a0c" => :el_capitan
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
