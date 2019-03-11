class GccAT49 < Formula
  def osmajor
    `uname -r`.chomp
  end

  desc "The GNU Compiler Collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2"
  sha256 "6c11d292cd01b294f9f84c9a59c230d80e9e4a47e5c6355f046bb36d4f358092"
  revision 1

  bottle do
    sha256 "0c4f2650325b060bf72beafd78dabab80973ee4ab330d4de16eb648b88225096" => :high_sierra
    sha256 "01a231e69b3c3e10a9e6aa99b5cbb6077eb1a011660bbbf06871ee262b6f31e6" => :sierra
    sha256 "1c407f31d58ab8e41230a83c6ffd1d77503c0c6528ccbc182f6888c23c5fb972" => :el_capitan
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  depends_on :maximum_macos => [:high_sierra, :build]

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-4.3.2.tar.bz2"
    sha256 "936162c0312886c21581002b79932829aa048cfaf9937c6265aeaa14f1cd1775"

    # Upstream patch to fix gmp.h header use in C++ compilation with libc++
    # https://gmplib.org/repo/gmp/rev/6cd3658f5621
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/010a4dc3/gmp%404/4.3.2.patch"
      sha256 "7865e09e154d4696e850779403e6c75be323f069356dedb7751cf1575db3a148"
    end
  end

  resource "mpfr" do
    url "https://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2"
    mirror "https://mirrorservice.org/sites/sourceware.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2"
    sha256 "c7e75a08a8d49d2082e4caee1591a05d11b9d5627514e678f02d66a124bcf2ba"
  end

  resource "mpc" do
    url "https://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz"
    sha256 "e664603757251fd8a352848276497a4c79b7f8b21fd8aedd5cc0598a38fee3e4"
  end

  resource "isl" do
    url "https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.12.2.tar.bz2"
    mirror "https://mirrorservice.org/sites/distfiles.macports.org/isl/isl-0.12.2.tar.bz2"
    sha256 "f4b3dbee9712850006e44f0db2103441ab3d13b406f77996d1df19ee89d11fb4"
  end

  resource "cloog" do
    url "https://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
    mirror "https://mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/c/cloog/cloog_0.18.4.orig.tar.gz"
    sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  end

  # Fix build with Xcode 9
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82091
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/c2dae73416/gcc%404.9/xcode9.patch"
      sha256 "92c13867afe18ccb813526c3b3c19d95a2dd00973f9939cf56ab7698bdd38108"
    end
  end

  # Fix issues with macOS 10.13 headers and parallel build on APFS
  if MacOS.version == :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b7c7883d/gcc%404.9/high_sierra_2.patch"
      sha256 "c7bcad4657292f6939b7322eb5e821c4a110c4f326fd5844890f0e9a85da8cae"
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # Build dependencies in-tree, to avoid having versioned formulas
    resources.each { |r| r.stage(buildpath/r.name) }

    version_suffix = version.to_s.slice(/\d\.\d/)

    args = [
      "--build=x86_64-apple-darwin#{osmajor}",
      "--prefix=#{prefix}",
      "--libdir=#{lib}/gcc/#{version_suffix}",
      "--enable-languages=c,c++,fortran,objc,obj-c++",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-system-zlib",
      "--enable-libstdcxx-time=yes",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      "--enable-plugin",
      # Use 'bootstrap-debug' build configuration to force stripping of object
      # files prior to comparison during bootstrap (broken by Xcode 6.3).
      "--with-build-config=bootstrap-debug",
      # A no-op unless --HEAD is built because in head warnings will
      # raise errors. But still a good idea to include.
      "--disable-werror",
      "--with-pkgversion=Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=https://github.com/Homebrew/homebrew-core/issues",
      # Even when suffixes are appended, the info pages conflict when
      # install-info is run.
      "MAKEINFO=missing",
      "--disable-nls",
      "--enable-multilib",
    ]

    # Ensure correct install names when linking against libgcc_s;
    # see discussion in https://github.com/Homebrew/homebrew/pull/34303
    inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}"

    mkdir "build" do
      unless MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path.
        # "native-system-headers" will be appended
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{MacOS.sdk_path}"
      end

      system "../configure", *args
      system "make", "bootstrap"

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.
      system "make", "install"
    end

    # Handle conflicts between GCC formulae.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    info.rmtree
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
    system bin/"gcc-4.9", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`
  end
end
