class Glibc < Formula
  desc "The GNU C Library"
  homepage "https://www.gnu.org/software/libc/download.html"
  url "https://ftpmirror.gnu.org/glibc/glibc-2.19.tar.bz2"
  sha256 "2e293f714187044633264cd9ce0183c70c3aa960a2f77812a6390a3822694d15"
  # tag "linuxbrew"

  bottle do
    prefix "/home/linuxbrew/.linuxbrew"
    cellar "/home/linuxbrew/.linuxbrew/Cellar"
    sha256 "c680445237c7df6c84cb1218d0bf2b76b1d43b92dc165ec6aa537b4c1c064336" => :x86_64_linux
  end

  option "with-current-kernel", "Compile for compatibility with kernel not older than your current one"

  # binutils 2.20 or later is required
  depends_on "binutils" => [:build, :recommended]

  # Linux kernel headers 2.6.19 or later are required
  depends_on "linux-headers" => [:build, :recommended]

  def install
    # -Os confuses valgrind.
    ENV.O2

    mkdir "build" do
      args = [
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--enable-obsolete-rpc",
        # Fix error: selinux/selinux.h: No such file or directory
        "--without-selinux",
      ]
      kernel_version = `uname -r`.chomp.split("-")[0]
      args << "--enable-kernel=#{kernel_version}" if build.with? "current-kernel"
      args << "--with-binutils=#{Formula["binutils"].bin}" if build.with? "binutils"
      args << "--with-headers=#{Formula["linux-headers"].include}" if build.with? "linux-headers"
      system "../configure", *args

      system "make" # Fix No rule to make target libdl.so.2 needed by sprof
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end
  end

  def post_install
    # Fix permissions
    chmod 0755, [lib/"ld-#{version}.so", lib/"libc-#{version}.so"]

    # Install ld.so symlink.
    ln_sf lib/"ld-linux-x86-64.so.2", HOMEBREW_PREFIX/"lib/ld.so"

    # Compile locale definition files
    mkdir_p lib/"locale"
    locales = ENV.map { |k, v| v if k[/^LANG$|^LC_/] && v != "C" }.compact
    locales << "en_US.UTF-8" # Required by gawk make check
    locales.uniq.each do |locale|
      lang, charmap = locale.split(".", 2)
      if !charmap.nil?
        system bin/"localedef", "-i", lang, "-f", charmap, locale
      else
        system bin/"localedef", "-i", lang, locale
      end
    end

    # Set the local time zone
    sys_localtime = Pathname.new "/etc/localtime"
    brew_localtime = Pathname.new prefix/"etc/localtime"
    (prefix/"etc").install_symlink sys_localtime if sys_localtime.exist? && !brew_localtime.exist?

    # Set zoneinfo correctly using the system installed zoneinfo
    sys_zoneinfo = Pathname.new "/usr/share/zoneinfo"
    brew_zoneinfo = Pathname.new share/"zoneinfo"
    share.install_symlink sys_zoneinfo if sys_zoneinfo.exist? && !brew_zoneinfo.exist?
  end

  test do
    system "#{lib}/ld-#{version}.so 2>&1 |grep Usage"
    system "#{lib}/libc-#{version}.so", "--version"
    system "#{bin}/locale", "--version"
  end
end
