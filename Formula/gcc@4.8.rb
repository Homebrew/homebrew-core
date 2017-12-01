class GccAT48 < Formula
  desc "GNU compiler collection"

  def arch
    if Hardware::CPU.type == :intel
      if MacOS.prefer_64_bit?
        "x86_64"
      else
        "i686"
      end
    elsif Hardware::CPU.type == :ppc
      if MacOS.prefer_64_bit?
        "powerpc64"
      else
        "powerpc"
      end
    end
  end

  def osmajor
    `uname -r`.chomp
  end

  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-4.8.5/gcc-4.8.5.tar.bz2"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-4.8.5/gcc-4.8.5.tar.bz2"
  sha256 "22fb1e7e0f68a63cee631d85b20461d1ea6bda162f03096350e38c8d427ecf23"

  bottle do
    rebuild 2
    sha256 "d1092bf457e37a92cc1e9d89ec9f044b29942607dca7e7893f4f94038f8e057e" => :sierra
    sha256 "c997fbd5dfcc1816838860eae37f8a21d5993b04e234a4b2bc56c085aa7cac11" => :el_capitan
    sha256 "1934330fbab7b2ed72befdf25f8f0c6f7084e3d136aefac9ef52577848b19f30" => :yosemite
  end

  if MacOS.version >= :yosemite
    # Fixes build on El Capitan
    # https://trac.macports.org/ticket/48471
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/dcfc5a2e6/gcc48/define_non_standard_clang_macros.patch"
      sha256 "e727383c9186fdc36f804c69ad550f5cfd2b996e37083be94c0c9aa8fde226ee"
    end
    # Fixes build with Xcode 7.
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66523
    patch do
      url "https://gcc.gnu.org/bugzilla/attachment.cgi?id=35773"
      sha256 "db4966ade190fff4ed39976be8d13e84839098711713eff1d08920d37a58f5ec"
    end
  end

  option "without-fortran", "Build without the gfortran compiler"
  option "with-java", "Build the gcj compiler"
  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "with-profiled-build", "Make use of profile guided optimization when bootstrapping GCC"

  deprecated_option "enable-java" => "with-java"
  deprecated_option "enable-all-languages" => "with-all-languages"
  deprecated_option "enable-nls" => "with-nls"
  deprecated_option "enable-profiled-build" => "with-profiled-build"

  depends_on MaximumMacOSRequirement => :sierra
  depends_on "gmp@4"
  depends_on "libmpc@0.8"
  depends_on "mpfr@2"
  depends_on "cloog"
  depends_on "isl@0.12"
  depends_on "ecj" if build.with?("java") || build.with?("all-languages")

  fails_with :gcc_4_0

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  def pour_bottle?
    MacOS::CLT.installed?
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    if build.with? "all-languages"
      # Everything but Ada, which requires a pre-existing GCC Ada compiler
      # (gnat) to bootstrap. GCC 4.6.0 add go as a language option, but it is
      # currently only compilable on Linux.
      languages = %w[c c++ fortran java objc obj-c++]
    else
      # C, C++, ObjC compilers are always built
      languages = %w[c c++ objc obj-c++]

      languages << "fortran" if build.with? "fortran"
      languages << "java" if build.with? "java"
    end

    version_suffix = version.to_s.slice(/\d\.\d/)

    args = [
      "--build=#{arch}-apple-darwin#{osmajor}",
      "--prefix=#{prefix}",
      "--libdir=#{lib}/gcc/#{version_suffix}",
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp@4"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr@2"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc@0.8"].opt_prefix}",
      "--with-cloog=#{Formula["cloog"].opt_prefix}",
      "--with-isl=#{Formula["isl@0.12"].opt_prefix}",
      "--with-system-zlib",
      "--enable-libstdcxx-time=yes",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      "--enable-plugin",
      # A no-op unless --HEAD is built because in head warnings will
      # raise errors. But still a good idea to include.
      "--disable-werror",
      "--with-pkgversion=Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=https://github.com/Homebrew/homebrew-core/issues",
      # Even when suffixes are appended, the info pages conflict when
      # install-info is run.
      "MAKEINFO=missing",
    ]

    # Use 'bootstrap-debug' build configuration to force stripping of object
    # files prior to comparison during bootstrap (broken by Xcode 6.3).
    # This causes bottle errors for gcc48 on Mountain Lion, so scope it to 10.10.
    args << "--with-build-config=bootstrap-debug" if MacOS.version >= :yosemite

    args << "--disable-nls" if build.without? "nls"

    if build.with?("java") || build.with?("all-languages")
      args << "--with-ecj-jar=#{Formula["ecj"].opt_prefix}/share/java/ecj.jar"
    end

    if MacOS.prefer_64_bit?
      args << "--enable-multilib"
    else
      args << "--disable-multilib"
    end

    # Ensure correct install names when linking against libgcc_s;
    # see discussion in https://github.com/Homebrew/homebrew/pull/34303
    inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}"

    mkdir "build" do
      unless MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path.
        # "native-system-header"s will be appended
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{MacOS.sdk_path}"
      end

      system "../configure", *args

      if build.with? "profiled-build"
        # Takes longer to build, may bug out. Provided for those who want to
        # optimise all the way to 11.
        system "make", "profiledbootstrap"
      else
        system "make", "bootstrap"
      end

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.

      system "make", "install"
    end

    # Handle conflicts between GCC formulae
    # Rename libiberty.a.
    Dir.glob(prefix/"**/libiberty.*") { |file| add_suffix file, version_suffix }
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Rename java properties
    if build.with?("java") || build.with?("all-languages")
      config_files = [
        "#{lib}/logging.properties",
        "#{lib}/security/classpath.security",
        "#{lib}/i386/logging.properties",
        "#{lib}/i386/security/classpath.security",
      ]

      config_files.each do |file|
        add_suffix file, version_suffix if File.exist? file
      end
    end
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system bin/"gcc-4.8", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`
  end
end
