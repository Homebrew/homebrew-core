class CutterCli < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://github.com/clear-code/cutter"
  url "https://github.com/clear-code/cutter/archive/refs/tags/1.2.9.tar.gz"
  sha256 "9ee1d9edf465110cad864889e70df681f4f5df55470a302593e5d9208249940e"
  license "LGPL-3.0-or-later"
  head "https://github.com/clear-code/cutter.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "2fdeb139a7a097e21c0b3af2d95875b73e8377865422a960b87dc4a632a09122"
    sha256 arm64_sequoia: "4269bdfaa7adb093818d5bf76cb5ae1a87759872845b0d8b95e6dcee2c779c8f"
    sha256 arm64_sonoma:  "315fa8bf0c67e9fa5bd8843219545f6d8fcf17acab28dc78d1b4451e55730295"
    sha256 sonoma:        "26430181959f637d2eff67e251bca6e8514d9f3c23c888ca04cd65ead28b1092"
    sha256 arm64_linux:   "80317a429c5daf9d5160e61074aadf4f89a2f853067c3883ae46fcefd368d82e"
    sha256 x86_64_linux:  "25bb198a72fcaa22ec6b5240ed0e0c3da587e0cfae7c1663e2b464a5de2af13f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
