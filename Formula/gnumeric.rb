class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.49.tar.xz"
  sha256 "91c072ec95c32e00b156ffe8015c93b32b8edf368f9041436193cfa32e84ed57"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256 arm64_big_sur: "2017f502250fc654acf20956ffa1894c8dd04fdaba9759eb0862c05a2047df3c"
    sha256 big_sur:       "72d9127c0c9ab4e661d42b4c885b85de3469a06bbf1cc8012cb198c9b338cca5"
    sha256 catalina:      "fdbffb8faa080825c809e8384ebbd7e8624b46de1fbd677dcf4dd5bddd377cec"
    sha256 mojave:        "29408d0f90f55698c76afe425564151764faf3670c298ec7415e86f9ed0a3752"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "goffice"
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "rarian"

  uses_from_macos "bison"

  on_linux do
    depends_on "perl"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    on_linux do
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
