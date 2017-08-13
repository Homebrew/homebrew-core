class GccAT46 < Formula
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

  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-4.6.4/gcc-4.6.4.tar.bz2"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-4.6.4/gcc-4.6.4.tar.bz2"
  sha256 "35af16afa0b67af9b8eb15cafb76d2bc5f568540552522f5dc2c88dd45d977e8"
  revision 2

  bottle do
    sha256 "08fa2595627a85927e6cfd3eeb89af93e4f41598cda83ee28b5b213afa72b0c5" => :sierra
    sha256 "f423fb652caf588aee4e9b4b9936cd7fa203d4cc3e61175a5b5e93163d0f80bc" => :el_capitan
    sha256 "f60768524f18e5d070469a736ce439f965eebbf76089913fd6881b4c1d779e78" => :yosemite
  end

  # Fixes build with Xcode 7.
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66523
  patch do
    url "https://gcc.gnu.org/bugzilla/attachment.cgi?id=35773"
    sha256 "db4966ade190fff4ed39976be8d13e84839098711713eff1d08920d37a58f5ec"
  end

  option "with-fortran", "Build the gfortran compiler"
  option "with-java", "Build the gcj compiler"
  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "with-profiled-build", "Make use of profile guided optimization when bootstrapping GCC"

  deprecated_option "enable-fortran" => "with-fortran"
  deprecated_option "enable-java" => "with-java"
  deprecated_option "enable-all-languages" => "with-all-languages"
  deprecated_option "enable-nls" => "with-nls"
  deprecated_option "enable-profiled-build" => "with-profiled-build"

  depends_on "gmp@4"
  depends_on "libmpc@0.8"
  depends_on "mpfr@2"
  depends_on "ppl@0.11"
  depends_on "cloog@0.15"
  depends_on "ecj" if build.with?("java") || build.with?("all-languages")

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  def pour_bottle?
    MacOS::CLT.installed?
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/05dab25ebcba1614370b589a8cdb7b7d0e341007/lang/gcc46/files/gcc-4.6-cloog_lang_c.patch"
    sha256 "51e1c5981784b99ac65aed0fc2c50be5a3e023b45cea4e20b308a70f2a0661b4"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/580a803587c463c9d5a68bcaa91fa75f384fa268/lang/gcc46/files/enable_libstdcxx_time_yes.patch"
    sha256 "e9e34c10db7849cc2f72e8e8d4d5e9cd1b3a2fe92fe317183fc575286999179f"
  end

  # Don't check Darwin kernel version (GCC PR target/61407
  # <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61407>).
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/70b8c296e68e90d13e589c9d1ffae73f52484a3a/lang/gcc46/files/remove-kernel-version-check.patch"
    sha256 "7f23c4e98b3a673a9d0fbbe1636e72e210d4739f6f0df9ffe45f59df8ef578eb"
  end

  # Handle OS X deployment targets correctly (GCC PR target/63810
  # <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63810>).
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/70b8c296e68e90d13e589c9d1ffae73f52484a3a/lang/gcc46/files/macosx-version-min.patch"
    sha256 "d8ad7c90e9de6a6288310ffe12498747da8db4c703317362e06c8298af7066ef"
  end

  # Don't link with "-flat_namespace -undefined suppress" on Yosemite and
  # later (#45483).
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/77a7df3e41b6fac5c94934329cedb2fee8830344/lang/gcc46/files/yosemite-libtool.patch"
    sha256 "9fdcc58d6303e6c649e745f9dece182244874d40cbaf743cd8b5f8ecb0e72b5c"
  end

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
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp@4"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr@2"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc@0.8"].opt_prefix}",
      "--with-ppl=#{Formula["ppl@0.11"].opt_prefix}",
      "--with-cloog=#{Formula["cloog@0.15"].opt_prefix}",
      "--with-system-zlib",
      # This ensures lib, libexec, include are sandboxed so that they
      # don't wander around telling little children there is no Santa
      # Claus.
      "--enable-version-specific-runtime-libs",
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

    args << "--disable-nls" if build.without? "nls"

    if build.with?("java") || build.with?("all-languages")
      args << "--with-ecj-jar=#{Formula["ecj"].opt_prefix}/share/java/ecj.jar"
    end

    if MacOS.prefer_64_bit?
      args << "--enable-multilib"
    else
      args << "--disable-multilib"
    end

    mkdir "build" do
      unless MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path.
        # "native-system-headers" will be appended
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

    # Handle conflicts between GCC formulae.
    # Remove libffi stuff, which is not needed after GCC is built.
    Dir.glob(prefix/"**/libffi.*") { |file| File.delete file }
    # Rename libiberty.a.
    Dir.glob(prefix/"**/libiberty.*") { |file| add_suffix file, version_suffix }
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    info.rmtree
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
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system bin/"gcc-4.6", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`
  end
end
