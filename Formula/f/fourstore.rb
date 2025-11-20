class Fourstore < Formula
  desc "Efficient, stable RDF database"
  homepage "https://github.com/4store/4store"
  url "https://github.com/4store/4store/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "e511f1adb094e2506545d4773a6005a462f6b4532731e91f1115b038ab25a8f0"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c5baea4e48a6bdc63c9b24b606eadd3b02a9659605011306941b044f37d3c6c1"
    sha256 arm64_sequoia: "5c9987aad4c2ab997ef0c9f359ea11ed1a39d61ab536b16661e006a28b55e8f9"
    sha256 arm64_sonoma:  "0aab4c5aa2a0f8c0d4f759604d159196fdc8ccc52ccdaa65f8fd65322ad2cbc7"
    sha256 sonoma:        "463dc6fd4f9af1fdcd701090c40bb3b3eb5db90465cf6574c91be35448b0a6ac"
    sha256 arm64_linux:   "a5163f5dd78472121fb698688d5b9c2ca43988320d34479a9ffc765a9b7213cd"
    sha256 x86_64_linux:  "d98981cc3228b17fb2ad4364a186756c88d9f8499c60d4bad3ea6d5a3c86513a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "pcre"
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "readline"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: query.o:(.bss+0x0): multiple definition of `rasqal_mutex'
    ENV.append_to_cflags "-fcommon" if OS.linux?
    # Upstream issue https://github.com/4store/4store/issues/138
    # Otherwise .git directory is needed
    (buildpath/".version").write version.to_s

    system "./autogen.sh"
    system "./configure", "--with-storage-path=#{var}/fourstore",
                          "--sysconfdir=#{pkgetc}",
                          *std_configure_args
    system "make", "install"

    (var/"fourstore").mkpath
  end

  def caveats
    <<~EOS
      Databases will be created at #{var}/fourstore.

      Create and start up a database:
          4s-backend-setup mydb
          4s-backend mydb

      Load RDF data:
          4s-import mydb datafile.rdf

      Start up HTTP SPARQL server without daemonizing:
          4s-httpd -p 8000 -D mydb

      See https://4store.danielknoell.de/trac/wiki/Documentation/ for more information.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/4s-admin --version")
  end
end
