require "os/linux/glibc"

class BrewedGlibcNotOlderRequirement < Requirement
  fatal true

  satisfy(build_env: false) do
    Glibc.version >= OS::Linux::Glibc.system_version
  end

  def message
    <<~EOS
      Your system's glibc version is #{OS::Linux::Glibc.system_version}, and Homebrew's glibc version is #{Glibc.version}.
      Installing a version of glibc that is older than your system's can break formulae installed from source.
    EOS
  end

  def display_s
    "System glibc < #{Glibc.version}"
  end
end

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
  VERSION = nil
end

class LinuxKernelRequirement < Requirement
  fatal true

  MINIMUM_LINUX_KERNEL_VERSION = "2.6.32".freeze

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

class Glibc < Formula
  desc "GNU C Library"
  homepage "https://www.gnu.org/software/libc/"
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.23.tar.gz"
  sha256 "2bd08abb24811cda62e17e61e9972f091f02a697df550e2e44ddcfb2255269d2"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    skip "glibc is pinned to the version present in Homebrew CI"
  end

  bottle do
    sha256 x86_64_linux: "8f5509c5a5fe85b923c196da5bb969d759a70a6a0e228110c5440a8719dc4c8e"
  end

  depends_on "binutils" => :build
  depends_on GawkRequirement => :build
  depends_on "linux-headers@4.4" => :build
  depends_on MakeRequirement => :build
  depends_on SedRequirement => :build
  depends_on BrewedGlibcNotOlderRequirement
  depends_on :linux
  depends_on LinuxKernelRequirement

  # GCC 4.7 or later is required.
  fails_with gcc: "4.6"

  def install
    # Fix Error: `loc1@GLIBC_2.2.5' can't be versioned to common symbol 'loc1'
    # See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=869717
    # Fixed in glibc 2.24
    inreplace "misc/regexp.c", /^(char \*loc[12s]);$/, "\\1 __attribute__ ((nocommon));"

    # Setting RPATH breaks glibc.
    %w[
      LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
      HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
    ].each { |x| ENV.delete x }

    # Use brewed ld.so.preload rather than the hotst's /etc/ld.so.preload
    inreplace "elf/rtld.c", '= "/etc/ld.so.preload";', '= SYSCONFDIR "/ld.so.preload";'

    mkdir "build" do
      args = [
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--enable-obsolete-rpc",
        "--without-selinux",
        "--with-binutils=#{Formula["binutils"].bin}",
        "--with-headers=#{Formula["linux-headers"].include}",
      ]
      system "../configure", *args
      system "make", "all"
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end
  end

  def post_install
    # Install ld.so symlink.
    ln_sf lib/"ld-linux-x86-64.so.2", HOMEBREW_PREFIX/"lib/ld.so"

    # Compile locale definition files
    mkdir_p lib/"locale"

    # Get all extra installed locales from the system, except C locales
    locales = ENV.map do |k, v|
      v if k[/^LANG$|^LC_/] && v != "C" && !v.start_with?("C.")
    end.compact

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
    brew_localtime = prefix/"etc/localtime"
    (prefix/"etc").install_symlink sys_localtime if sys_localtime.exist? && brew_localtime.exist?

    # Set zoneinfo correctly using the system installed zoneinfo
    sys_zoneinfo = Pathname("/usr/share/zoneinfo")
    brew_zoneinfo = share/"zoneinfo"
    share.install_symlink sys_zoneinfo if sys_zoneinfo.exist? && !brew_zoneinfo.exist?
  end

  test do
    assert_match "Usage", shell_output("#{lib}/ld-#{version}.so 2>&1", 127)
    safe_system "#{lib}/libc-#{version}.so", "--version"
    safe_system "#{bin}/locale", "--version"
  end
end
