class GccArmEmbedded < Formula
  desc "GNU Embedded Toolchain for Arm Cortex-M/R processors"
  homepage "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm"
  url "https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-src.tar.bz2"
  version "9-2019-q4-major"
  sha256 "f162a655f222319f75862d7aba9ff8a4a86f752392e4f3c5d9ef2ee8bc13be58"

  depends_on "gnu-tar" => :build
  depends_on :xcode => ["10.0", :build]
  uses_from_macos "expat"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libelf"
  depends_on "libmpc"
  depends_on "mpfr"

  def install
    ENV.deparallelize
    inreplace "build-common.sh", "JOBS=1", "JOBS=`sysctl -n hw.ncpu`"

    # `clean_env` removes most ENV variables as a precaution. This can't happen if we want to use Superenv.
    inreplace "build-common.sh", /clean_env$/, ""

    # Need to adjust `build-toolchain.sh` to point it to where Homebrew puts the dependencies.
    # Request to add functionality to `build-toolchain.sh` to customize locations of dependencies:
    # https://answers.launchpad.net/gcc-arm-embedded/+question/686033
    inreplace "build-toolchain.sh", /--with-gmp\S*/, "--with-gmp=#{Formula["gmp"].opt_prefix}"
    inreplace "build-toolchain.sh", /--with-mpfr\S*/, "--with-mpfr=#{Formula["mpfr"].opt_prefix}"
    inreplace "build-toolchain.sh", /--with-mpc\S*/, "--with-mpc=#{Formula["libmpc"].opt_prefix}"
    inreplace "build-toolchain.sh", /--with-isl\S*/, "--with-isl=#{Formula["isl"].opt_prefix}"
    inreplace "build-toolchain.sh", /--with-libelf\S*/, "--with-libelf=#{Formula["libelf"].opt_prefix}"
    inreplace "build-toolchain.sh", /--with-libexpat-prefix\S*/, "--with-libexpat-prefix=#{MacOS.sdk_path}/usr"
    inreplace "build-toolchain.sh", "-I$BUILDDIR_NATIVE/host-libs/zlib/include", ""
    inreplace "build-toolchain.sh", "-L$BUILDDIR_NATIVE/host-libs/zlib/lib", ""
    inreplace "build-toolchain.sh", "-L$BUILDDIR_NATIVE/host-libs/usr/lib", ""

    cd "src" do
      Dir.each_child(".") do |f|
        system "tar", "xf", f
      end
    end

    # So we can use gnu-tar here
    ENV.prepend_path "PATH", "#{Formula["gnu-tar"].opt_libexec}/gnubin"

    system "./build-toolchain.sh", "--skip_steps=mingw32,mingw32-gdb-with-python,package_sources,howto,manual"

    prefix.install Dir["install-native/arm-none-eabi", "install-native/bin", "install-native/lib", "install-native/share"]
    man.install Dir["#{share}/doc/gcc-arm-none-eabi/man/*"]
  end

  test do
    # 'error Unsupported architecture' is thrown by XCode preprocessor, removing CPATH fixes this
    ENV.delete "CPATH"
    cp_r "#{share}/gcc-arm-none-eabi/samples/", testpath
    system "make", "-C", testpath/"samples/src"

    Dir.each_child(testpath/"samples/src") do |d|
      next if File.file?(testpath/"samples/src/#{d}")

      ohai "Checking #{d} for axf and map files..."
      refute_predicate Dir.glob(testpath/"samples/src/#{d}/*.axf"), :empty?
      refute_predicate Dir.glob(testpath/"samples/src/#{d}/*.map"), :empty?
    end
  end
end
