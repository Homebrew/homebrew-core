require "os/linux/glibc"

class GlibcBaseRequirement < Requirement
  def message
    tool = self.class::TOOL
    version = self.class::VERSION
    <<~EOS
      #{[tool, version].compact.join(" ")} is required to build glibc.
      Install #{tool} with your host package manager if you have sudo access:
        sudo apt-get install #{tool}
        sudo yum install #{tool}
    EOS
  end

  def display_s
    "#{self.class::TOOL} #{self.class::VERSION}".strip
  end
end

class GawkRequirement < GlibcBaseRequirement
  fatal true
  satisfy(build_env: false) { which(TOOL).present? }
  TOOL = "gawk".freeze
  VERSION = "3.1.2 (or later)".freeze
end

class MakeRequirement < GlibcBaseRequirement
  fatal true
  satisfy(build_env: false) { which(TOOL).present? }
  TOOL = "make".freeze
  VERSION = "3.79 (or later)".freeze
end

class SedRequirement < GlibcBaseRequirement
  fatal true
  satisfy(build_env: false) { which(TOOL).present? }
  TOOL = "sed".freeze
  VERSION = "3.02 (or later)".freeze
end

class LinuxKernelRequirement < Requirement
  fatal true

  MINIMUM_LINUX_KERNEL_VERSION = "2.6.16".freeze

  satisfy(build_env: false) do
    OS.kernel_version >= MINIMUM_LINUX_KERNEL_VERSION
  end

  def message
    <<~EOS
      Linux kernel version #{MINIMUM_LINUX_KERNEL_VERSION} or later is required by glibc.
      Your system has Linux kernel version #{OS.kernel_version}.
    EOS
  end

  def display_s
    "Linux kernel #{MINIMUM_LINUX_KERNEL_VERSION} (or later)"
  end
end

class GlibcAT217 < Formula
  desc "GNU C Library"
  homepage "https://www.gnu.org/software/libc/"
  url "https://ftpmirror.gnu.org/gnu/glibc/glibc-2.17.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glibc/glibc-2.17.tar.gz"
  sha256 "a3b2086d5414e602b4b3d5a8792213feb3be664ffc1efe783a829818d3fca37a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_linux:  "c7e6ac88b5b12fdbecfe5f82846bbd0071fc7ff7c5b8d01c6896ed1318416499"
    sha256 x86_64_linux: "23e8506f5365138f86d33a39c62dd543813acdc71d160c9de6bde623c6b2d1ef"
  end

  keg_only :versioned_formula

  depends_on GawkRequirement => :build
  depends_on "linux-headers@4.4" => :build
  depends_on MakeRequirement => :build
  depends_on SedRequirement => :build
  depends_on :linux
  depends_on LinuxKernelRequirement

  # Backport of:
  # https://sourceware.org/git/?p=glibc.git;a=commit;h=e9177fba13549a8e2a6232f46080e5c6d3e467b1
  patch do
    url "https://git.centos.org/rpms/glibc/raw/ca483cc5b0e3e6a595a2c103755dee4d72f14f25/f/SOURCES/glibc-rh1500908.patch"
    sha256 "48bfb15f5a26161bbef3d58e18d44876a170ddbfcc5922a39c77fd8da9fe68f6"
  end

  # Backport of:
  # https://sourceware.org/git/?p=glibc.git;a=commit;h=43d06ed218fc8be58987bdfd00e21e5720f0b862
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/glibc/2.17-aarch64-dl-machine.diff"
    sha256 "ece66819f9ef3a1b73081d0f5cda8c814b5204d25c07f8a7adb8209ee286c39d"
  end

  def install
    # Fix checking version of gnumake... 4.3, bad
    inreplace "configure",
              "3.79* | 3.[89]*)",
              "3.79* | 3.[89]* | [4-9].* | [1-9][0-9]*)"

    # Fix checking version of gcc-11... 11.4.0, bad
    inreplace "configure",
              "4.[3-9].* | 4.[1-9][0-9].* | [5-9].* )",
              "4.[3-9].* | 4.[1-9][0-9].* | [5-9].* | [1-9][0-9]* )"

    # Setting RPATH breaks glibc.
    %w[
      LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
      HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
    ].each { |x| ENV.delete x }

    # Fix relocation R_X86_64_32S against symbol `__libc_csu_fini' can not be
    # used when making a PIE object; recompile with -fPIE
    # See https://sourceware.org/pipermail/libc-alpha/2020-March/111688.html
    ENV.append "LDFLAGS", "-no-pie" if Hardware::CPU.intel?

    # Use brewed ld.so.preload rather than the host's /etc/ld.so.preload
    inreplace "elf/rtld.c",
              '= "/etc/ld.so.preload";',
              '= SYSCONFDIR "/ld.so.preload";'

    mkdir "build" do
      args = [
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--sysconfdir=#{etc}",
        "--without-gd",
        "--without-selinux",
        "--with-headers=#{Formula["linux-headers@4.4"].include}",
      ]
      system "../configure", *args
      system "make", "all"
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end

    # Fix quoting of filenames that contain @
    inreplace [lib/"libc.so", lib/"libpthread.so"],
              %r{(#{Regexp.escape(prefix)}/\S*) },
              '"\1" '

    # Remove executables/dylibs that link with system libnsl
    [
      sbin/"nscd",
      lib/"libnss_nisplus-#{version}.so",
      lib/"libnss_compat-#{version}.so",
      lib/"libnss_nis-#{version}.so",
    ].each(&:unlink)
  end

  def post_install
    # Compile locale definition files
    mkdir_p lib/"locale"

    # Get all extra installed locales from the system, except C locales
    locales = ENV.filter_map do |k, v|
      v if k[/^LANG$|^LC_/] && v != "C" && !v.start_with?("C.")
    end

    # en_US.UTF-8 is required by gawk make check
    locales = (locales + ["en_US.UTF-8"]).sort.uniq
    ohai "Installing locale data for #{locales.join(" ")}"
    locales.each do |locale|
      lang, charmap = locale.split(".", 2)
      if charmap.present?
        charmap = "UTF-8" if charmap == "utf8"
        system bin/"localedef", "-i", lang, "-f", charmap, locale
      else
        system bin/"localedef", "-i", lang, locale
      end
    end

    # Set the local time zone
    sys_localtime = Pathname("/etc/localtime")
    brew_localtime = etc/"localtime"
    etc.install_symlink sys_localtime if sys_localtime.exist? && !brew_localtime.exist?

    # Set zoneinfo correctly using the system installed zoneinfo
    sys_zoneinfo = Pathname("/usr/share/zoneinfo")
    brew_zoneinfo = share/"zoneinfo"
    share.install_symlink sys_zoneinfo if sys_zoneinfo.exist? && !brew_zoneinfo.exist?
  end

  test do
    assert_match "Usage", shell_output("#{lib}/ld-#{version}.so 2>&1", 127)
    safe_system lib/"libc.so.6", "--version"
    safe_system bin/"locale", "--version"
  end
end
