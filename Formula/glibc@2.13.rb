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
  VERSION = "3.0 (or later)".freeze
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

  MINIMUM_LINUX_KERNEL_VERSION = "2.6.0".freeze

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

class GlibcAT213 < Formula
  desc "GNU C Library"
  homepage "https://www.gnu.org/software/libc/"
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.13.tar.gz"
  sha256 "bd90d6119bcc2898befd6e1bbb2cb1ed3bb1c2997d5eaa6fdbca4ee16191a906"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  bottle do
    sha256 x86_64_linux: "fcfd8511ae57b126f377789db1294e74bd48c2be941badd8e33a378dbdef9e16"
  end

  keg_only :versioned_formula

  depends_on GawkRequirement => :build
  depends_on "linux-headers@4.4" => :build
  depends_on MakeRequirement => :build
  depends_on SedRequirement => :build
  depends_on :linux
  depends_on LinuxKernelRequirement

  # Fix getconf files having random bytes at the end of their names.
  # Backport of patch included in 2.16.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d87dbbdadb5aa4899fd293be70f8087a412d6a59/glibc/2.13-getconf.diff"
    sha256 "e945c11c76655cba6f3e1c13d847e57d6e591a5af3fd7d3eb2c200475bfcdaed"
  end

  def install
    # Fix checking version of gcc-5 5.4.0, bad
    inreplace "configure", "3.4* | 4.[0-9]* )", "3.4* | [4-9].* )"

    # Fix checking version of make... 4.1, bad
    inreplace "configure", "3.79* | 3.[89]*)", "3.79* | 3.[89]* | 4.*)"

    # Fix configure: error: linker with -z relro support required
    inreplace "configure", 'grep "z relro" 1>&5', 'grep "z relro" 1>&5;true'

    # Fix error: inlining failed in call to always_inline function not inlinable
    # See http://www.yonch.com/tech/78-compiling-glibc
    ENV.append_to_cflags "-U_FORTIFY_SOURCE"

    # Fix multiple definition of __libc_multiple_libcs and _dl_addr_inside_object
    # See http://www.yonch.com/tech/78-compiling-glibc
    ENV.append_to_cflags "-fno-stack-protector"

    # Setting RPATH breaks glibc.
    %w[
      LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
      HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
    ].each { |x| ENV.delete x }

    # Use brewed ld.so.preload rather than the host's /etc/ld.so.preload
    inreplace "elf/rtld.c", '= "/etc/ld.so.preload";', "= \"#{prefix}/etc/ld.so.preload\";"

    mkdir "build" do
      args = [
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--enable-obsolete-rpc",
        "--without-selinux",
        "--with-headers=#{Formula["linux-headers@4.4"].include}",
      ]
      system "../configure", *args
      system "make", "all"
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end

    # Fix quoting of filenames that contain @
    inreplace [lib/"libc.so", lib/"libpthread.so"], %r{(#{Regexp.escape(prefix)}/\S*) }, '"\1" '
  end

  def post_install
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
