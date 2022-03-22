class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  license "GPL-2.0-or-later"
  revision 9

  bottle do
    sha256 arm64_monterey: "f4a3934702cc68077a096d0baca50a4baf033309cec38b2225b144a4bd825b45"
    sha256 arm64_big_sur:  "03a102fc5cbf319029a6b536b60caf5db40396b25e1d6de1eda1baf297cb0d81"
    sha256 monterey:       "941432357b54d13c0b0333c120b72ec0ce467230a05de210a0a4837e3a898e31"
    sha256 big_sur:        "4300af03702b1873b307890bfb3bf9e08da08e43c401c958a2dcf796d56a34e8"
    sha256 catalina:       "8384f85dfc725d9a754030a2f94320124845b3d63968a2a3348a918afd096415"
    sha256 mojave:         "3e25c1930c085b61c073b5015895db250ec1113b3102384ebf84c1f8d0a65731"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtkmm3"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?
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
    # Disable this part of the test on Linux because display is not available.
    system "#{bin}/prefixsuffix", "--version" if OS.mac?
  end
end
