class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.8.1/qalculate-gtk-4.8.1.tar.gz"
  sha256 "b97e84a5f52b277eefb8e5b9b60cfc7aeed3b243f92a9725ff9cc3aeeacf41c2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "7d598b6ab8a1631a64c3606b8299aa874ca5aad2b0dc74b0a71f1e8aba358c44"
    sha256 arm64_ventura:  "25d2c13c609ce148da7b0d16ef1db5661f45919a02fc60cde907284a10a2c95f"
    sha256 arm64_monterey: "327782673f6d44feb5fd94780fb6f035660d8509eb89bf7646d3566c90e73f12"
    sha256 arm64_big_sur:  "cf33a03eb79acaf470ffa04ba1af4255dc37de223f1220f23a97498762456025"
    sha256 sonoma:         "239ec5c9c49cf04eeb69858adcd870176563fde38a42702d977a8a68dad8f5b1"
    sha256 ventura:        "4fb639709e34ddecedc522ff2d011a4ab7446a3621fd7e3343b69ca70f8e186f"
    sha256 monterey:       "54c81069d96282328cb53a96831c483ea47be9cf0aaab82866f27eaf6a5b9cb4"
    sha256 big_sur:        "a23b0d80a5097b4d4644e6d16481898cd5e7f3128fcef228c99bdaaa38cccbce"
    sha256 x86_64_linux:   "f7ae75461c3f3428886efa4b8e16fccfff19fd6ddbb89578f7b73c804cb0d9fa"
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
