class GnomeThemesExtra < Formula
  desc "Extra themes for the GNOME desktop environment"
  homepage "https://gitlab.gnome.org/GNOME/gnome-themes-extra"
  url "https://download.gnome.org/sources/gnome-themes-extra/3.28/gnome-themes-extra-3.28.tar.xz"
  sha256 "7c4ba0bff001f06d8983cfc105adaac42df1d1267a2591798a780bac557a5819"
  license "LGPL-2.1-or-later"

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

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
