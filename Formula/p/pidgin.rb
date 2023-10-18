class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.14.12/pidgin-2.14.12.tar.bz2"
  sha256 "2b05246be208605edbb93ae9edc079583d449e2a9710db6d348d17f59020a4b7"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://sourceforge.net/projects/pidgin/files/Pidgin/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sonoma:   "b2e5c0e2731a46e7979f8906ef13157590979ad6cb060c276f276ce1a6ebfb18"
    sha256 arm64_ventura:  "f3a2601a1197c63c8e63cfed471019e1e5422511206848d6b37b6383431ce87d"
    sha256 arm64_monterey: "945f3685930f41562f171b64f8714f80d52c52ab454b084201c493f4ab00d10b"
    sha256 sonoma:         "d856de13e81f1e274b423f6c6a43aff86c7d4e9291cf288242beddc243bc65bd"
    sha256 ventura:        "1cfa9ff27dab1b9d09e7ce7a14b0b4a28b9b69acf9167cdd2459bc2c23a5f4a3"
    sha256 monterey:       "f88f5105b1d6b113c39e448455dc8069bdca68fb9d3a36a203218428a4ab76c6"
    sha256 x86_64_linux:   "77505b9bb23f796cbaa6948e23a83e25e96ad88fc509a92f451456fcbeac6569"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libgcrypt"
  depends_on "libgnt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "pango"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "ncurses"
  uses_from_macos "perl"
  uses_from_macos "tcl-tk"

  on_linux do
    depends_on "libsm"
    depends_on "libxscrnsaver"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz"
      sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
    end
  end

  # Finch has an equal port called purple-otr but it is a NIGHTMARE to compile
  # If you want to fix this and create a PR on Homebrew please do so.
  resource "pidgin-otr" do
    url "https://otr.cypherpunks.ca/pidgin-otr-4.0.2.tar.gz"
    sha256 "f4b59eef4a94b1d29dbe0c106dd00cdc630e47f18619fc754e5afbf5724ebac4"
  end

  def install
    unless OS.mac?
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

      perl_resources = %w[XML::Parser]
      perl_resources.each do |r|
        resource(r).stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
          system "make", "install"
        end
      end
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-avahi
      --disable-dbus
      --disable-doxygen
      --disable-gevolution
      --disable-gstreamer
      --disable-gstreamer-interfaces
      --disable-gtkspell
      --disable-meanwhile
      --disable-vv
      --enable-gnutls=yes
    ]

    args += if OS.mac?
      %W[
        --with-tclconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
        --with-tkconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework
        --without-x
      ]
    else
      %W[
        --with-tclconfig=#{Formula["tcl-tk"].opt_lib}
        --with-tkconfig=#{Formula["tcl-tk"].opt_lib}
        --with-ncurses-headers=#{Formula["ncurses"].opt_include}
      ]
    end

    ENV["ac_cv_func_perl_run"] = "yes" if MacOS.version == :high_sierra

    # patch pidgin to read plugins and allow them to live in separate formulae which can
    # all install their symlinks into these directories. See:
    #   https://github.com/Homebrew/homebrew-core/pull/53557
    inreplace "finch/finch.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/finch\""
    inreplace "libpurple/plugin.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/purple-2\""
    inreplace "pidgin/gtkmain.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/pidgin\""
    inreplace "pidgin/gtkutils.c", "DATADIR", "\"#{HOMEBREW_PREFIX}/share\""

    unless OS.mac?
      # Fix linkage error due to RPATH missing directory with libperl.so
      perl = DevelopmentTools.locate("perl")
      perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}/CORE"
    end

    system "./configure", *args
    system "make", "install"

    resource("pidgin-otr").stage do
      ENV.prepend "CFLAGS", "-I#{Formula["libotr"].opt_include}"
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/finch", "--version"
    system "#{bin}/pidgin", "--version"

    pid = fork { exec "#{bin}/pidgin", "--config=#{testpath}" }
    sleep 5
    Process.kill "SIGTERM", pid
  end
end
