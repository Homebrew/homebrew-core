class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v0.9.12/libqalculate-0.9.12.tar.gz"
  sha256 "4b59ab24e45c3162f02b7e316168ebaf7f0d2911a2164d53b501e8b18a9163d2"

  bottle do
    sha256 "8e6dfe4e45213d687961fbc44b77e6900233f7bc9e44449c391cf512a8ab73f6" => :sierra
    sha256 "369f1490d60045930bbe3d7b62a6e07233aa2589817e6de4c96bcccbb86b0404" => :el_capitan
    sha256 "4b6de765ce80651675e070e1fb2793cc730b05bf9ba5f6bd5f4ec97476441407" => :yosemite
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gettext"
  depends_on "readline"
  depends_on "wget"

  # Fix "error: typedef redefinition with different types"
  # Upstream commit from 9 Jun 2017 "Remove clang build fix"
  patch do
    url "https://github.com/Qalculate/libqalculate/commit/63c6b4f.patch"
    sha256 "47d2f3233d104eb591cb16c34648e163a99a85d240661eacb5a8f3ab5d4fb268"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
