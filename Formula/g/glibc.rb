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
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.39.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/glibc/glibc-2.39.tar.gz"
  sha256 "97f84f3b7588cd54093a6f6389b0c1a81e70d99708d74963a2e3eab7c7dc942d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    skip "glibc is pinned to the version present in Homebrew CI"
  end

  bottle do
    rebuild 1
    sha256 x86_64_linux: "91e866deda35d20e5e5e7a288ae0902b7692ec4398d4267c74c84a6ebcc7cdd9"
  end

  keg_only "it can shadow system glibc if linked"

  depends_on BrewedGlibcNotOlderRequirement
  depends_on :linux
  depends_on "linux-headers@5.15"
  depends_on LinuxKernelRequirement

  # Automatic bootstrapping is only supported for Intel.
  on_intel do
    resource "bootstrap-binutils" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.0/bootstrap-x86_64-binutils-2.43.1.tar.gz"
      sha256 "5deed1e65b9121f21a6ebcd673b7d3f37e678fa77a9b087fdf97e846d38fe92d"
    end

    resource "bootstrap-bison" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.0/bootstrap-x86_64-bison-3.8.2.tar.gz"
      sha256 "97d82cf4b3b00cfacbf142679ae77cbb8e80490f564a4d1d4921b892994c073b"
    end

    resource "bootstrap-gawk" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.0/bootstrap-x86_64-gawk-5.3.1.tar.gz"
      sha256 "fbcf19d79eafb1921abd11ab6c1cb662c7e7984ba19ea4a10ac88dd27fcf645b"
    end

    resource "bootstrap-gcc" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.0/bootstrap-x86_64-gcc-9.5.0.tar.gz"
      sha256 "8472155b74727dc84e396866f2d224443d2ab7765f57a7c9638ccacce98dd585"
    end

    resource "bootstrap-make" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.0/bootstrap-x86_64-make-4.4.1.tar.gz"
      sha256 "d68f444c6491946a3a5fc9a0521fded4559b3936241158c54d05edcc90a50e5e"
    end

    resource "bootstrap-python3" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.0/bootstrap-x86_64-python3-3.11.10.tar.gz"
      sha256 "0fc2735fee338f6fb25bce707d1bdc783e1b8c49814e6d7d897d992dad1d72be"
    end

    resource "bootstrap-sed" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.0/bootstrap-x86_64-sed-4.9.tar.gz"
      sha256 "64ff039f91e6043b5ce4cc48561a7f1ae53ad0f47aefed8239dfb5686bf1d547"
    end
  end

  def install
    # Automatic bootstrapping is only supported for Intel.
    if Hardware::CPU.intel?
      # Set up bootstrap resources in /tmp/homebrew.
      bootstrap_dir = Pathname.new("/tmp/homebrew")
      bootstrap_dir.mkpath

      resources.each do |r|
        r.stage do
          cp_r Pathname.pwd.children, bootstrap_dir
        end
      end

      # Add bootstrap resources to PATH.
      ENV.prepend_path "PATH", bootstrap_dir/"bin"
      # Make sure we use the bootstrap GCC rather than other compilers.
      ENV["CC"] = bootstrap_dir/"bin/gcc"
      ENV["CXX"] = bootstrap_dir/"bin/g++"
      # The MAKE variable must be set to the bootstrap make - including it in the path is not enough.
      ENV["MAKE"] = bootstrap_dir/"bin/make"
      # Add -march=core2 and -O2 when building in CI since we are not using the compiler shim.
      ENV.append "CFLAGS", "-march=core2 -O2" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    # Setting RPATH breaks glibc.
    %w[
      LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
      HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
    ].each { |x| ENV.delete x }

    # Use brewed ld.so.preload rather than the hotst's /etc/ld.so.preload
    inreplace "elf/rtld.c", '= "/etc/ld.so.preload";', '= SYSCONFDIR "/ld.so.preload";'

    mkdir "build" do
      args = [
        "--disable-crypt",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--sysconfdir=#{etc}",
        "--without-gd",
        "--without-selinux",
        "--with-binutils=#{bootstrap_dir}/bin",
        "--with-headers=#{Formula["linux-headers@5.15"].include}",
      ]
      system "../configure", *args
      system "make", "all"
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end

    # Add ld.so.conf (will be written to HOMEBREW_PREFIX/etc/ld.so.conf)
    atomic_write_with_mode etc/"ld.so.conf", <<~EOS
      # This file is generated by Homebrew. Do not modify.
      #{opt_lib}  # ensure Homebrew Glibc always comes first
      include #{ld_so_conf_d}/*.conf
    EOS

    # Create ld.so.conf.d directories
    mkpath_with_mode ld_so_conf_d

    # Add README in etc/ld.so.conf.d
    atomic_write_with_mode ld_so_conf_d/"README", <<~EOS
      This is the Homebrew's ld configuration directory

      .conf files in this directory will be loaded automatically by ldconfig.

      Files will be included in lexicographical order, so you can control the order of
      files with a prefix, e.g.:

          00-first.conf
          50-middle.conf
          99-last.conf
    EOS

    # Add Homebrew lib to ld search paths
    atomic_write_with_mode ld_so_conf_d/"90-homebrew.conf", "#{HOMEBREW_PREFIX}/lib"

    # Add system ld search paths (disabled by default)
    atomic_write_with_mode system_ld_so_conf, <<~EOS
      # The system ld search paths
      #
      # If you want Homebrew's ld.so to search for libraries in the system paths,
      # remove the "#{system_ld_so_conf.extname}" suffix of this file.
      # Mixing the Homebrew and system library search paths is very risky and can
      # cause problems. Please do this only if you know what you are doing, i.e., at
      # your own risk.
      include /etc/ld.so.conf
    EOS

    rm(etc/"ld.so.cache")
  ensure
    # Delete bootstrap binaries after build is finished.
    rm_r(bootstrap_dir)
  end

  def post_install
    # Rebuild ldconfig cache
    rm(etc/"ld.so.cache") if (etc/"ld.so.cache").exist?
    system sbin/"ldconfig"

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

  def caveats
    <<~EOS
      The Homebrew's Glibc has been installed with the following executables:
        #{opt_bin}/ldd
        #{opt_bin}/ld.so
        #{opt_sbin}/ldconfig

      By default, Homebrew's linker will not search for the system's libraries. If you
      want Homebrew to do so, run:

        cp "#{system_ld_so_conf}" "#{ld_so_conf_d}/#{system_ld_so_conf.stem}"
        brew postinstall glibc

      to append the system libraries to Homebrew's ld search paths. This is risky and
      **highly not recommended**, because it may cause linkage to Homebrew libraries
      mixed with system libraries.
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ld.so --help")
    safe_system lib/"libc.so.6", "--version"
    safe_system bin/"locale", "--version"
  end

  def ld_so_conf_d
    etc/"ld.so.conf.d"
  end

  def system_ld_so_conf
    ld_so_conf_d/"99-system-ld.so.conf.example"
  end

  def atomic_write_with_mode(path, content, mode: "u=rw,go-wx")
    file = Pathname(path)
    file.atomic_write("#{content.chomp}\n")
    return if mode.blank?

    # Mode can be a string, use FileUtils.chmod
    chmod mode, file
  end

  def mkpath_with_mode(path, mode: "go-wx", recursive: false)
    dir = Pathname(path)
    dir.mkpath
    return if mode.blank?

    # Mode can be a string, use FileUtils.chmod or FileUtils.chmod_R
    if recursive
      chmod_R mode, dir
    else
      chmod mode, dir
    end
  end
end
