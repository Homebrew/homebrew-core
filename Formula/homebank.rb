class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.7.tar.gz"
  sha256 "8eedbe4246477935bd3882c1a628d7fd6036f6467be998c2558bdf4b39b0eb5f"

  bottle do
    sha256 "7235b69f24196c27772a251da502207f92861b16df5baa35bdac5844f5799f40" => :mojave
    sha256 "0338cfd9bc1ba58e7d5a41bc70366c436c45d9a7c63249b6775a8feb0a5bbc6a" => :high_sierra
    sha256 "f813a76ef9f5d030b04f27b5dc00b3028d5d8cf265e7589569911e2f23ac840c" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
