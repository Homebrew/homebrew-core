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

  MINIMUM_LINUX_KERNEL_VERSION = "3.2".freeze

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
  url "https://ftpmirror.gnu.org/gnu/glibc/glibc-2.39.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glibc/glibc-2.39.tar.gz"
  sha256 "97f84f3b7588cd54093a6f6389b0c1a81e70d99708d74963a2e3eab7c7dc942d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    skip "glibc is pinned to the version present in Homebrew CI"
  end

  bottle do
    rebuild 2
    sha256 arm64_linux:  "01a46dbd217ab6379da50f9285da81ebaf0928c3457fbb04542b745bc80cb27f"
    sha256 x86_64_linux: "2fe24afa0fd4034a66340b61fbe952ec7628d5eb30358191730c9ba2b6a1d421"
  end

  keg_only "it can shadow system glibc if linked"

  depends_on BrewedGlibcNotOlderRequirement
  depends_on :linux
  depends_on "linux-headers@6.8"
  depends_on LinuxKernelRequirement

  resource "bootstrap-binutils" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-aarch64-binutils-2.47.tar.gz"
      sha256 "f50e67aefcb31334e4152ced007f944264bbe665313321cae75a252aac16fcb3"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-x86_64-binutils-2.47.tar.gz"
      sha256 "3d26286c7ae0d6a6eeedbd2a1d00b599a6b5f24be0806b174e46d9012f99c1db"
    end
  end

  resource "bootstrap-bison" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-aarch64-bison-3.8.2.tar.gz"
      sha256 "c80d45bc799b136d871fc553391925f948a066196434b56a41f84af75b383373"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-x86_64-bison-3.8.2.tar.gz"
      sha256 "c582adee9bb0fa7612993c5e89b3c7eda09512c22bd99ce6e28e77b3edb986e5"
    end
  end

  resource "bootstrap-gawk" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-aarch64-gawk-5.4.1.tar.gz"
      sha256 "f6172dad95e904216dc82b273ded3f7b882a1a8e34106bcee13c659c61532e68"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-x86_64-gawk-5.4.1.tar.gz"
      sha256 "86eecfc46cbbb7c0c31f39f91088ca4e255bc54319fff063e4e11ee0e1849de2"
    end
  end

  resource "bootstrap-gcc" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-aarch64-gcc-12.5.0.tar.gz"
      sha256 "c489c9c5e6246c984a4d5472e3fac951dfc8c71b6bd3a607ef64196b03ddc853"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-x86_64-gcc-12.5.0.tar.gz"
      sha256 "20da2f82374ee0b5b93ef5a44ec7de8c92e2b60e450fcf74b4af29036f10a4fb"
    end
  end

  resource "bootstrap-make" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-aarch64-make-4.4.1.tar.gz"
      sha256 "b6b3c1c689a4a2e86bbdae6fe7e1aeb4b23698a698833691746f05b6f4eb8435"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-x86_64-make-4.4.1.tar.gz"
      sha256 "8b49e5306d984fce9e8849d77ebfceee97f36c6c1e3f11649f5de73cc0aebee4"
    end
  end

  resource "bootstrap-python3" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-aarch64-python3-3.11.15.tar.gz"
      sha256 "ebb3cc61affb7c2c04e5b33901c0ca9490d81189dc44946ac431537caa90db7b"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-x86_64-python3-3.11.15.tar.gz"
      sha256 "07a77afa777268cf5f9ea72f9a566044da0dc770a8e3af87e6d2b0381cbe0718"
    end
  end

  resource "bootstrap-sed" do
    on_arm do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-aarch64-sed-4.10.tar.gz"
      sha256 "e2982336e09efdfd03f58df3537984835fc57cd1b7dab79a8616cac6c0e6717e"
    end
    on_intel do
      url "https://github.com/Homebrew/glibc-bootstrap/releases/download/1.3.1/bootstrap-x86_64-sed-4.10.tar.gz"
      sha256 "4881e4b81c1ca21ee540e90fcdebcc947ab26c879bfabb1cd1885525f47b3498"
    end
  end

  # Apply CVE patches from Ubuntu
  patch do
    url "https://archive.ubuntu.com/ubuntu/pool/main/g/glibc/glibc_2.39-0ubuntu8.8.debian.tar.xz"
    mirror "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/glibc/2.39-0ubuntu8.8/glibc_2.39-0ubuntu8.8.debian.tar.xz"
    sha256 "ff1aa3bb3eba4f302a99c9b957cacff6d79f26e9b0e663e379bf70a4f39d4283"
    type :backport
    resolves "CVE-2024-2961", "CVE-2024-33599", "CVE-2024-33600", "CVE-2024-33601", "CVE-2024-33602",
             "CVE-2025-0395", "CVE-2025-5702", "CVE-2025-8058", "CVE-2025-15281",
             "CVE-2026-0861", "CVE-2026-0915", "CVE-2026-4046", "CVE-2026-4437", "CVE-2026-4438",
             "CVE-2026-5435", "CVE-2026-5450", "CVE-2026-5928", "CVE-2026-6238"
    apply "patches/any/CVE-2024-2961.patch",
          "patches/any/CVE-2024-33599.patch",
          "patches/any/CVE-2024-33600_1.patch",
          "patches/any/CVE-2024-33600_2.patch",
          "patches/any/CVE-2024-33601_33602.patch",
          "patches/any/CVE-2025-0395.patch",
          "patches/any/CVE-2025-5702.patch",
          "patches/any/CVE-2025-8058.patch",
          "patches/CVE-2025-15281.patch",
          "patches/CVE-2026-0861.patch",
          "patches/CVE-2026-0915.patch",
          "patches/CVE-2026-4046.patch",
          "patches/CVE-2026-5450.patch",
          "patches/CVE-2026-5928.patch",
          "patches/CVE-2026-6238-pre1.patch",
          "patches/CVE-2026-6238-pre2.patch",
          "patches/CVE-2026-6238-pre3.patch",
          "patches/CVE-2026-6238-pre4.patch",
          "patches/CVE-2026-5435.patch",
          "patches/CVE-2026-6238-1.patch",
          "patches/CVE-2026-6238-2.patch",
          "patches/CVE-2026-443x.patch"
  end

  # Backport of various test suite fixes
  patch do
    file "Patches/glibc/2.39-test-fixes.patch"
    type :backport
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
        "--with-headers=#{Formula["linux-headers@6.8"].include}",
        "--with-bugurl=#{tap.issues_url}",
        "--with-pkgversion=Homebrew glibc (#{pkg_version})",

        # Security hardening options used by Arch Linux, Debian, Fedora and Gentoo
        "--enable-bind-now",
        "--enable-fortify-source",
        "--enable-stack-protector=strong",
      ]
      # Ubuntu glibc has CET enabled and Ubuntu GCC injects -fcf-protection.
      # Using permissive as non-default prefix setups that mix relocatable
      # bottles with source installs could trigger CET error if toolchain
      # used does not inject -fcf-protection[=full].
      args << "--enable-cet=permissive" if Hardware::CPU.intel?

      cflags = "-O2 #{ENV["HOMEBREW_OPTFLAGS"]} -fstack-clash-protection"
      cflags += " -mbranch-protection=standard" if Hardware::CPU.arm64?

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
        sysv_dir = if Hardware::CPU.arm64?
          "aarch64"
        elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
          "x86_64/64"
        end
        if sysv_dir
          inreplace "../sysdeps/unix/sysv/linux/#{sysv_dir}/libc.abilist",
                    /(_nl_default_dirname.*?)0x12/,
                    "\\10x#{(localedir.to_s.length + 1).to_s(16)}"
        end

        # Avoid Intel CI runner timeout on tst-malloc-too-large-malloc-hugetlb2
        ENV["TIMEOUTFACTOR"] = "4" if Hardware::CPU.intel?

        # Workaround to skip test failures seen when running in sandbox
        xfail_tests = ["test-xfail-tst-realpath-toolong=yes"]
      end

      system "../configure", *args, "CFLAGS=#{cflags}"
      system "make", "all"
      system "make", "check", *xfail_tests if build.bottle?
      system "make", "install", "localedir=#{share}/locale"
      prefix.install_symlink "lib" => "lib64"
    end

    # Add ld.so.conf (will be linked to HOMEBREW_PREFIX/etc/ld.so.conf rather than
    # written there so the file can be removed on uninstall and work with binutils)
    (prefix/"etc/ld.so.conf").write <<~EOS
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

  post_install_steps do
    symlink "{{prefix}}/etc/ld.so.conf", "{{etc}}/ld.so.conf", overwrite: true
    remove "{{etc}}/ld.so.cache"
    run "ldconfig", base: :sbin
    configure_glibc_runtime
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
