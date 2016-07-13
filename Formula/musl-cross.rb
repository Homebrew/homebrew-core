class MuslCross < Formula
  desc "Linux cross compilers based on musl libc"
  homepage "https://github.com/richfelker/musl-cross-make"
  url "https://github.com/richfelker/musl-cross-make/archive/v0.9.2.tar.gz"
  sha256 "828b4913c80018d25fff5809aa6691141be4dc9001d3204ae9a94a8e71a5176f"
  head "https://github.com/richfelker/musl-cross-make.git"

  bottle do
    cellar :any_skip_relocation
  end

  option "with-arm-hf", "Build cross-compilers targeting arm-linux-musleabihf"
  option "with-arm", "Build cross-compilers targeting arm-linux-musleabi"
  option "with-i486", "Build cross-compilers targeting i486-linux-musl"
  option "without-x86_64", "Do not build cross-compilers targeting x86_64-linux-musl"

  depends_on "gnu-sed" => :build
  depends_on "homebrew/dupes/make" => :build

  resource "linux-4.4.10.tar.xz" do
    url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.10.tar.xz"
    sha256 "4ac22e4a619417213cfdab24714413bb9118fbaebe6012c6c89c279cdadef2ce"
  end

  resource "mpfr-3.1.4.tar.bz2" do
    url "https://ftpmirror.gnu.org/mpfr/mpfr-3.1.4.tar.bz2"
    sha256 "d3103a80cdad2407ed581f3618c4bed04e0c92d1cf771a65ead662cc397f7775"
  end

  resource "mpc-1.0.3.tar.gz" do
    url "https://ftpmirror.gnu.org/mpc/mpc-1.0.3.tar.gz"
    sha256 "617decc6ea09889fb08ede330917a00b16809b8db88c29c31bfbb49cbf88ecc3"
  end

  resource "gmp-6.1.0.tar.bz2" do
    url "https://ftpmirror.gnu.org/gmp/gmp-6.1.0.tar.bz2"
    sha256 "498449a994efeba527885c10405993427995d3f86b8768d8cdf8d9dd7c6b73e8"
  end

  resource "musl-1.1.15.tar.gz" do
    url "https://www.musl-libc.org/releases/musl-1.1.15.tar.gz"
    sha256 "97e447c7ee2a7f613186ec54a93054fe15469fe34d7d323080f7ef38f5ecb0fa"
  end

  resource "binutils-2.25.1.tar.bz2" do
    url "https://ftpmirror.gnu.org/binutils/binutils-2.25.1.tar.bz2"
    sha256 "b5b14added7d78a8d1ca70b5cb75fef57ce2197264f4f5835326b0df22ac9f22"
  end

  resource "config.sub" do
    url "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=3d5db9ebe860"
    sha256 "75d5d255a2a273b6e651f82eecfabf6cbcd8eaeae70e86b417384c8f4a58d8d3"
  end

  resource "gcc-5.3.0.tar.bz2" do
    url "https://ftpmirror.gnu.org/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2"
    sha256 "b84f5592e9218b73dbae612b5253035a7b34a9a1f7688d2e1bfaaf7267d5c4db"
  end

  def install
    ENV.deparallelize

    if build.with? "x86_64"
      targets = ["x86_64-linux-musl"]
    else
      targets = []
    end
    if build.with? "arm-hf"
      targets.push "arm-linux-musleabihf"
    end
    if build.with? "arm"
      targets.push "arm-linux-musleabi"
    end
    if build.with? "i486"
      targets.push "i486-linux-musl"
    end

    (buildpath/"resources").mkpath
    resources.each do |resource|
      cp resource.fetch, buildpath/"resources"/resource.name
    end

    (buildpath/"config.mak").write <<-EOS.undent
    SOURCES = #{buildpath/"resources"}
    OUTPUT = #{libexec}

    # Recommended options for faster/simpler build:
    COMMON_CONFIG += --disable-nls
    GCC_CONFIG += --enable-languages=c,c++
    GCC_CONFIG += --disable-libquadmath --disable-decimal-float
    GCC_CONFIG += --disable-multilib
    # Recommended options for smaller build for deploying binaries:
    COMMON_CONFIG += CFLAGS="-g0 -Os" CXXFLAGS="-g0 -Os" LDFLAGS="-s"
    # Keep the local build path out of binaries and libraries:
    COMMON_CONFIG += --with-debug-prefix-map=$(PWD)=

    # https://llvm.org/bugs/show_bug.cgi?id=19650
    ifeq ($(shell $(CXX) -v 2>&1 | grep -c "clang"), 1)
    TOOLCHAIN_CONFIG += CXX="$(CXX) -fbracket-depth=512"
    endif
    EOS

    ENV.prepend_path "PATH", "#{Formula["gnu-sed"].opt_libexec}/gnubin"
    targets.each do |target|
      system Formula["make"].opt_bin/"gmake", "install", "TARGET=#{target}"
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
    #include <stdio.h>

    main()
    {
        printf("Hello, world!");
    }
    EOS

    if build.with? "x86_64"
      system "#{bin}/x86_64-linux-musl-cc", (testpath/"hello.c")
    end
    if build.with? "i486"
      system "#{bin}/i486-linux-musl-cc", (testpath/"hello.c")
    end
    if build.with? "arm-hf"
      system "#{bin}/arm-linux-musleabihf-cc", (testpath/"hello.c")
    end
    if build.with? "arm"
      system "#{bin}/arm-linux-musleabi-cc", (testpath/"hello.c")
    end
  end
end
