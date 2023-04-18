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
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.35.tar.gz"
  sha256 "3e8e0c6195da8dfbd31d77c56fb8d99576fb855fafd47a9e0a895e51fd5942d4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    skip "glibc is pinned to the version present in Homebrew CI"
  end

  bottle do
    sha256 x86_64_linux: "274dd06ae6ecaee3025d6bf21cf4c7641df9a1cc3973e162911a1f4a76000a24"
  end

  keg_only "it can shadow system glibc if linked"

  depends_on BrewedGlibcNotOlderRequirement
  depends_on :linux
  depends_on "linux-headers@5.15"
  depends_on LinuxKernelRequirement

  # Automatic bootstrapping is only supported for Intel.
  on_intel do
    resource "bootstrap-binutils" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-binutils-2.38.tar.gz"
      sha256 "a2971fd77743a1d82242736c646bfa201137a4df28d829b1aa7f556fc57215e2"
    end

    resource "bootstrap-bison" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-bison-3.8.2.tar.gz"
      sha256 "f914c0dee9fc8a200f6607d52a2d25c253b665d02aaac360711ebd5fbd9cb346"
    end

    resource "bootstrap-gawk" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-gawk-5.1.1.tar.gz"
      sha256 "ec3f0115b156b418a189f9868aaa0655f18c40f5c40f437e407ac60b7c749e0a"
    end

    resource "bootstrap-gcc" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-gcc-9.5.0.tar.gz"
      sha256 "d549cf096864de5da77b4f068fab3741636206f3b7ace593b46a226d726f4538"
    end

    resource "bootstrap-make" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-make-4.3.tar.gz"
      sha256 "aa684eff83e5a986391475547c29b3ade04a307aa5730866aa5d2caa905e7166"
    end

    resource "bootstrap-python3" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-python3-3.9.13.tar.gz"
      sha256 "93d258ab9240d247a66322926deb6728e2aa7877711196fde02d716c20ada490"
    end

    resource "bootstrap-sed" do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.0.0/bootstrap-sed-4.8.tar.gz"
      sha256 "404f86a92a15303f9b08960712ee8a8b398efc345d80b4e0401dd9ef82452046"
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
        "--enable-obsolete-rpc",
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

    rm_f etc/"ld.so.cache"
  ensure
    # Delete bootstrap binaries after build is finished.
    rm_rf bootstrap_dir
  end

  def post_install
    # Rebuild ldconfig cache
    rm_f etc/"ld.so.cache"
    system sbin/"ldconfig"

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
    safe_system "#{lib}/libc.so.6", "--version"
    safe_system "#{bin}/locale", "--version"
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
