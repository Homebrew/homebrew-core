class GnomeThemesExtra < Formula
  desc "Extra themes for the GNOME desktop environment"
  homepage "https://gitlab.gnome.org/GNOME/gnome-themes-extra"
  url "https://download.gnome.org/sources/gnome-themes-extra/3.28/gnome-themes-extra-3.28.tar.xz"
  sha256 "7c4ba0bff001f06d8983cfc105adaac42df1d1267a2591798a780bac557a5819"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc49731aec4652327aac34ead43265575048800ac75e769fb8effc8e975f6bad"
    sha256 cellar: :any,                 arm64_ventura:  "291bd9c91143fd2dac260a4ae70c37e77fb3da2e92d3fecd66f88c23cc95d320"
    sha256 cellar: :any,                 arm64_monterey: "35b85f8e887414d692cc57a6ada94634cbf446cad7e717714a499afcec1fe76e"
    sha256 cellar: :any,                 sonoma:         "764d0ca9feceaf6a174c242d135cbe7d04bed2b98eee1208b9f0258c9545857a"
    sha256 cellar: :any,                 ventura:        "11323caf0f8a1f3745f1f0ae6f0b5558590148a1eb0efd124a32b3ee945b50ab"
    sha256 cellar: :any,                 monterey:       "ce23ae32bafec76ac518498866c1e32d4587909ed9c69f24ba9b5796f30428e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f5c9c176b316179b530c7d28fb245f93881339b1ec7737685c85f3d0857248e"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].opt_libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    # To find gtk-update-icon-cache
    ENV.prepend_path "PATH", Formula["gtk+"].opt_libexec
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-gtk3-engine"
    system "make", "install"
  end

  test do
    assert_predicate share/"icons/HighContrast/scalable/actions/document-open-recent.svg", :exist?
    assert_predicate lib/"gtk-2.0/2.10.0/engines/libadwaita.so", :exist?
  end
end
