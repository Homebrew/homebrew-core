class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.4.tar.xz"
  sha256 "2cee38dd583ccbaa5bdf6c01ca5f88cc08758b9b144938a51a478eb2684b765e"
  revision 2

  bottle do
    sha256 "e165830cedc3a0955989746145b310cc03fe96b84f18b33c4c3f2b827bdd473c" => :sierra
    sha256 "7809bb97ebcd233a740c1e5b5cb0f291a902639a6479d5e53fdcfedd928b6582" => :el_capitan
    sha256 "01e46f8673fcf3fad0bccdd70e9bd6fac08f0f5b7035e85318a3add4db329a9b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"
  depends_on "libgcrypt"
  depends_on "sqlite"
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java"
    system "make"
    system "make", "install"
  end

  if MacOS.version >= :high_sierra
    patch do
      url "https://raw.githubusercontent.com/bai/formula-patches/a089089f6657bec65cad85dd2a4f105027682db6/libgda/0001-Convert-files-to-Unicode.patch"
      sha256 "2e25ee9ca86b3767485b26b19317e5188641e2dbfa6202bb204b16e332cca3a4"
    end

    patch do
      url "https://raw.githubusercontent.com/bai/formula-patches/e248bb75e2d481d312f31dccf8b5acbfee9adbec/libgda/glib-2.54-ftbfs.patch"
      sha256 "73f65147b1d7d3b78982c9ac562816e855db1b20d7ff346d9fd1ecb013864afc"
    end

    patch do
      url "https://raw.githubusercontent.com/bai/formula-patches/53ea4e47b0d799227e1de832f7af02038ed1499c/libgda/mysqlpatch.patch"
      sha256 "3b49117a8671ee6c8a599873a95f692b76720635b1c991f107540a84bc355abc"
    end
  end
end
