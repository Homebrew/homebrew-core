class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.14.12/pidgin-2.14.12.tar.bz2"
  sha256 "2b05246be208605edbb93ae9edc079583d449e2a9710db6d348d17f59020a4b7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/pidgin/files/Pidgin/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_ventura:  "a04309e2217e0983459955016b4460954c613eac84da8283afc8e2f4eb650d9e"
    sha256 arm64_monterey: "0167e1a59e189d616d909688dadfda1d9648ab7d3f84fbb8db34fb30e259b415"
    sha256 arm64_big_sur:  "cec31339d3e2a83f61fac179cd72bc2b00e63611a5a2561018db865f659983f5"
    sha256 ventura:        "4aa98090185eb17a74b68ec64bdf1551382d0778d01e00691395b488a0e3d027"
    sha256 monterey:       "d6407e69aad79bcf6ad08625510306e10a45e594af1ec225249647e180462b1b"
    sha256 big_sur:        "e70d0f821cb46ccd6d1e78855125db8c55e2bd4afeae7b20f933ec37de13d9ce"
    sha256 x86_64_linux:   "e45ab075f267eaa4dee89536c9a4561f3e5676221337274857c268fde1c8ed81"
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
  end

  # Finch has an equal port called purple-otr but it is a NIGHTMARE to compile
  # If you want to fix this and create a PR on Homebrew please do so.
  resource "pidgin-otr" do
    url "https://otr.cypherpunks.ca/pidgin-otr-4.0.2.tar.gz"
    sha256 "f4b59eef4a94b1d29dbe0c106dd00cdc630e47f18619fc754e5afbf5724ebac4"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

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
