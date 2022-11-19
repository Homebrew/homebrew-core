class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.53.tar.xz"
  sha256 "5568e4c8dceabb9028f1361d1045522f95f0a71daa59e973cbdd2d39badd4f02"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256 arm64_ventura:  "04ad53f4378a567dc37aea3bab40e4c44bbd10a6b32ecfa09fd1942304957281"
    sha256 arm64_monterey: "379f3f13f1b333394992650422cfed7f7bde81a5290d5f7ac06d4fa6952b2fe6"
    sha256 arm64_big_sur:  "17f27ff8fc570ec1b9b26e5a8c3c629838c815c1c71a1a3649a73ee86bd1a0f0"
    sha256 ventura:        "cb57caa716297c1954d907a04a99c2b00392032778f3e638af4c4b127af3fb06"
    sha256 monterey:       "0513b180accd11a2b0f89e39336869b92d19b57a016e43ad49163e693962760a"
    sha256 big_sur:        "2aac7daeeb5bf62575363a197171a31f091260152bf5c3b4196b7955a8ef9c94"
    sha256 catalina:       "b39e0b480d3f03b0be1313413ea013058bf9c4ff34bfd516a691c03157b2589a"
    sha256 x86_64_linux:   "1bdc477e8d7ef69df05582b93695313f9b4f89dc57f7392bc5c94ba3133c54a1"
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
