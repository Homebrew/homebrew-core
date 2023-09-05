class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.8.0/qalculate-gtk-4.8.0.tar.gz"
  sha256 "5d8ef3e5e613f000177172f220243f88c83afcfaa19ef0465d5c723f4859bd26"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "304a8c67044ee793cbd1a3515ae998271fec6f0e3cd98757309aa7b562750a15"
    sha256 arm64_monterey: "b50e2b5240a60dc7da88ca14617e16431d82459082cfb9c3c0f32fc0b4e70b03"
    sha256 arm64_big_sur:  "9a5643b5ee142167fcd6ea862c801fb40839a4fb14d42cbf3c978e2319134527"
    sha256 ventura:        "49ecfa48454c7d9e4fe2cf3bd2a5b214a96d35c364b74508e9df6958a7e578b7"
    sha256 monterey:       "84201823265d6c8290e630b9ab8c7a08e9da1065070b976db890859b04962677"
    sha256 big_sur:        "3b6d6d13ebf6ee522dd13234a1e1916f0323812de8d140f6cf49af4160967421"
    sha256 x86_64_linux:   "18db4e127d7189406af621551991641a5b3a105b2bd68f5ca4926daed75380a1"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
