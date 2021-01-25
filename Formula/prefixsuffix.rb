class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  license "GPL-2.0-or-later"
  revision 8

  livecheck do
    url :stable
  end

  bottle do
    sha256 "1a206fbaa56f4f914d6abe1c1cafc05252227f50acc7f87aaf941796e8bab383" => :big_sur
    sha256 "fa2029310d20bfb4ca37c1c879f1e80bff99aacd34b45f09d9dce497c3175133" => :arm64_big_sur
    sha256 "05aeea58be85836d1edd0bea80a9cc00e238286c710dfe142449a6ad5bf1f891" => :catalina
    sha256 "6b8a81c367bedd1384555dc5a98a64b2cc2acdf50495e071606467373ea2b503" => :mojave
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtkmm3"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/prefixsuffix", "--version"
  end
end
