class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.53.tar.xz"
  sha256 "5568e4c8dceabb9028f1361d1045522f95f0a71daa59e973cbdd2d39badd4f02"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256 arm64_monterey: "e0e9e6d7cb46c08b5cf72c98cfe4a06aa72d20da2e4b058c3e019e904edf5c8d"
    sha256 arm64_big_sur:  "49bf897a4d2df371fa2de568d8eb65cc86046c2b3662a334e38e847b3d970633"
    sha256 monterey:       "48d242c1c456ba6538f5bf64e04bbfb6c94a9300765bb92afacbac084c0d954f"
    sha256 big_sur:        "4611c4e0776363d32a92877ac36973c76fadca3343aebff1e902dc796a335f55"
    sha256 catalina:       "d4192e498fc5776d5463b86380cce584c1276c9a9766047e241217f6303d5341"
    sha256 x86_64_linux:   "dd029eb8fc1bc6ca5a011bd448b31b926b79e1930a1ca79f502617d2e63b0143"
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
    if OS.linux?
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
