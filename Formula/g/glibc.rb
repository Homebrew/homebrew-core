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
  url "https://ftpmirror.gnu.org/gnu/glibc/glibc-2.35.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glibc/glibc-2.35.tar.gz"
  sha256 "3e8e0c6195da8dfbd31d77c56fb8d99576fb855fafd47a9e0a895e51fd5942d4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2

  livecheck do
    skip "glibc is pinned to the version present in Homebrew CI"
  end

  bottle do
    sha256 arm64_linux:  "d62fe7730aa45aaaa6e0f3d61c12265c3f064c19acf0cee125caf505169b9c6d"
    sha256 x86_64_linux: "e462d46c498dd1ba590b11eab0f21901bc6ae2a3fac3a9fd2c730e2da7a62c8e"
  end

  keg_only "it can shadow system glibc if linked"

  depends_on BrewedGlibcNotOlderRequirement
  depends_on :linux
  depends_on "linux-headers@5.15"
  depends_on LinuxKernelRequirement

  resource "bootstrap-binutils" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-aarch64-binutils-2.43.1.tar.gz"
      sha256 "4eb48a302fd501a57be0c842c1657080abe96c1314473244f814df2ae676d951"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-x86_64-binutils-2.43.1.tar.gz"
      sha256 "56e5fdc9aa18d3b609969a60f03f103e99dde3a32bfc7139c66d83e185f4dfec"
    end
  end

  resource "bootstrap-bison" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-aarch64-bison-3.8.2.tar.gz"
      sha256 "59f5bacacc32fda6aa16427a3a894d5a1d0bc30cfc8b5e22f8b25580473e571e"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-x86_64-bison-3.8.2.tar.gz"
      sha256 "29c9763dbcb94e0816fc43ccc38835f2a6f17574eb23559e2f497bcef9d3e6ae"
    end
  end

  resource "bootstrap-gawk" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-aarch64-gawk-5.3.1.tar.gz"
      sha256 "8e966760d81396b118ad84f228e2c26dc72264aad20edbd34428f743c3a202e3"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-x86_64-gawk-5.3.1.tar.gz"
      sha256 "f209cf49bcb141a7f4b3e16a01492f23a2da59351e85f0ccc1757fae91ff63cd"
    end
  end

  resource "bootstrap-gcc" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-aarch64-gcc-9.5.0.tar.gz"
      sha256 "79d7e4a257a2fcdad62e400764810f375bfc3e7b9c46a9a981cbab7f2f1daf9f"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-x86_64-gcc-9.5.0.tar.gz"
      sha256 "f7f0c7293bb60644b2463351a4ba748b0b108ccda49d4a098aa13e331d26b8c3"
    end
  end

  resource "bootstrap-make" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-aarch64-make-4.4.1.tar.gz"
      sha256 "a0bf6d77a11763581f1236947fa1c7a89a4d6e4b5d0afbb019f7e2e48928580a"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-x86_64-make-4.4.1.tar.gz"
      sha256 "54a22f00ba061b6018cc14f4c1472eba5adf7045418d1993aebd35cd446851f7"
    end
  end

  resource "bootstrap-python3" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-aarch64-python3-3.11.10.tar.gz"
      sha256 "b8c30cfe774238c01e22a57718fbb7049c66d1d0236ac7e10079556633d0c1fe"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-x86_64-python3-3.11.10.tar.gz"
      sha256 "2de6cdd4e8a239fb18d70c140abf17708e32e34cf1a29c5754474201a206b1d8"
    end
  end

  resource "bootstrap-sed" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-aarch64-sed-4.9.tar.gz"
      sha256 "90558ff86eb9c4fa8046bed69ee9fb764905ed4022c99e21d6cb502f960fc6c2"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.1.1/bootstrap-x86_64-sed-4.9.tar.gz"
      sha256 "ba9d8b41362c9f7cf85bc36a7b685be8206d4cb32b364b6ca323621b976e89bb"
    end
  end

  # CVE rollup patch covering:
  # - CVE-2023-4806
  # - CVE-2023-4813
  # - CVE-2023-4911
  # - CVE-2023-5156
  # - CVE-2024-2961
  # - CVE-2024-33599
  # - CVE-2024-33600
  # - CVE-2024-33601
  # - CVE-2024-33602
  # - CVE-2025-0395
  # - CVE-2025-4802
  # - CVE-2025-8058
  # Plus various test suite fixes
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/glibc/2.35-cve-rollup-sep2025.patch"
    sha256 "ee42ca65793f8ea9f1cb3aeb5c9101ef412498a2635af11d576368cda8909f50"
  end

  def install
    # Automatic bootstrapping is only supported for x86_64 and aarch64.
    if (Hardware::CPU.intel? || Hardware::CPU.arm?) && Hardware::CPU.is_64_bit?
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
    end

    # Setting RPATH breaks glibc.
    %w[
      LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
      HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
    ].each { |x| ENV.delete x }

    # Use brewed ld.so.preload rather than the hotst's /etc/ld.so.preload
    inreplace "elf/rtld.c", '= "/etc/ld.so.preload";', '= SYSCONFDIR "/ld.so.preload";'

    # Changing this will change the ABI so we want to keep this stable.
    localedir = opt_share/"locale"

    mkdir "build" do
      args = [
        "--disable-crypt",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--sysconfdir=#{etc}",
        "--localedir=#{localedir}",
        "--without-gd",
        "--without-selinux",
        "--with-binutils=#{bootstrap_dir}/bin",
        "--with-headers=#{Formula["linux-headers@5.15"].include}",
        "--with-bugurl=#{tap.issues_url}",
        "--with-pkgversion=Homebrew glibc (#{pkg_version})",
      ]

      cflags = "-O2 #{ENV["HOMEBREW_OPTFLAGS"]}"
      cflags += " -mbranch-protection=standard" if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

      if build.bottle?
        # Some tests need some gcc libraries to be present.
        # However these must be built with glibc - unlike our stage0 bootstrap without glibc.
        # We are strongly assuming here that the host GCC is newer or equal to the bootstrap GCC,
        # but that's okay given this is just for the tests and is scoped to bottle builds only.
        # For real runtime usage, `brew` will automatically install Homebrew GCC after glibc.
        # Some of this might be simplified in Glibc 2.41+ when we can use `TEST_CC`.
        %w[libgcc_s.so.1 libstdc++.so.6 libgcc_eh.a].each do |lib|
          ln_s Utils.safe_popen_read("/usr/bin/cc", "-print-file-name=#{lib}").chomp, Pathname.pwd
        end
        gcc_eh = File.dirname(Utils.safe_popen_read("/usr/bin/cc", "-print-file-name=libgcc_eh.a").chomp)
        inreplace "../Makeconfig", /static-gnulib-tests := /, "\\0-L#{gcc_eh} "

        # We do break the ABI in one unavoidable way.
        # This is because `_nl_default_dirname` ABI varies based on the length of the install prefix.
        sysv_dir = if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
          "aarch64"
        elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
          "x86_64/64"
        end
        if sysv_dir
          inreplace "../sysdeps/unix/sysv/linux/#{sysv_dir}/libc.abilist",
                    /(_nl_default_dirname.*?)0x12/,
                    "\\10x#{(localedir.to_s.length + 1).to_s(16)}"
        end
      end

      system "../configure", *args, "CFLAGS=#{cflags}"
      system "make", "all"
      system "make", "check" if build.bottle?
      system "make", "install", "localedir=#{share}/locale"
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
    rm_r(bootstrap_dir) if bootstrap_dir
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
