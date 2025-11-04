class Aarch64MingwW64 < Formula
  desc "Minimalist GNU for Windows and GCC cross-compilers for Arm64"
  homepage "https://sourceforge.net/projects/mingw-w64/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v13.0.0.tar.bz2"
  sha256 "5afe822af5c4edbf67daaf45eec61d538f49eef6b19524de64897c6b95828caf"
  license "ZPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?release/mingw-w64[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  # binutils searches for zstd using pkg-config
  depends_on "pkgconf" => :build
  # Apple's makeinfo is old and has bugs
  depends_on "texinfo" => :build

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

  resource "binutils" do
    url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
    sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  end

  resource "gcc" do
    url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
    sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"

    patch do
      url "https://github.com/Windows-on-ARM-Experiments/gcc-woarm64/commit/b3295b9e3837da0afc882930dee2dd217ac85daf.patch?full_index=1"
      sha256 "b6200b0b8268cba442fc1fc1087717ec60ad4d331549af5212cc704f35d6f275"
    end
  end

  def install
    resource("binutils").stage do
      args = %W[
        --target=aarch64-w64-mingw32
        --with-sysroot=#{prefix}
        --prefix=#{prefix}
        --enable-targets=aarch64-w64-mingw32
        --disable-multilib
        --disable-nls
        --with-system-zlib
        --with-zstd
      ]
      mkdir "build" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end
    end

    mkdir "mingw-w64-headers/build" do
      system "../configure", "--host=aarch64-w64-mingw32", "--prefix=#{prefix}/aarch64-w64-mingw32"
      system "make"
      system "make", "install"
    end

    # Create a mingw symlink, expected by GCC
    ln_s "#{prefix}/aarch64-w64-mingw32", "#{prefix}/mingw"

    # Put the newly built binaries into our PATH
    ENV.prepend_path "PATH", bin.to_s

    # Build the GCC compiler
    resource("gcc").stage buildpath/"gcc"
    args = %W[
      --target=aarch64-w64-mingw32
      --with-sysroot=#{prefix}
      --with-native-system-header-dir=/mingw/include
      --prefix=#{prefix}
      --with-bugurl=#{tap.issues_url}
      --enable-languages=c,c++,objc,obj-c++,fortran
      --with-ld=#{bin}/aarch64-w64-mingw32-ld
      --with-as=#{bin}/aarch64-w64-mingw32-as
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-system-zlib
      --with-zstd
      --disable-multilib
      --disable-nls
      --enable-threads=posix
    ]

    mkdir "#{buildpath}/gcc/build" do
      system "../configure", *args
      system "make", "all-gcc"
      system "make", "install-gcc"
    end

    # Build the mingw-w64 runtime
    args = %W[
      CC=aarch64-w64-mingw32-gcc
      CXX=aarch64-w64-mingw32-g++
      CPP=aarch64-w64-mingw32-cpp
      --host=aarch64-w64-mingw32
      --with-sysroot=#{prefix}/aarch64-w64-mingw32
      --prefix=#{prefix}/aarch64-w64-mingw32
      --disable-lib32
      --disable-lib64
      --disable-libarm32
      --enable-libarm64
    ]

    mkdir "mingw-w64-crt/build" do
      system "../configure", *args
      # Resolves "Too many open files in system"
      # bfd_open failed open stub file dfxvs01181.o: Too many open files in system
      # bfd_open failed open stub file: dvxvs00563.o: Too many open files in systembfd_open
      # https://sourceware.org/bugzilla/show_bug.cgi?id=24723
      # https://sourceware.org/bugzilla/show_bug.cgi?id=23573#c18
      ENV.deparallelize do
        system "make"
        system "make", "install"
      end
    end

    # Build the winpthreads library
    # we need to build this prior to the
    # GCC runtime libraries, to have `-lpthread`
    # available, for `--enable-threads=posix`
    args = %W[
      CC=aarch64-w64-mingw32-gcc
      CXX=aarch64-w64-mingw32-g++
      CPP=aarch64-w64-mingw32-cpp
      --host=aarch64-w64-mingw32
      --with-sysroot=#{prefix}/aarch64-w64-mingw32
      --prefix=#{prefix}/aarch64-w64-mingw32
    ]
    mkdir "mingw-w64-libraries/winpthreads/build" do
      system "../configure", *args
      system "make"
      system "make", "install"
    end

    args = %W[
      --host=aarch64-w64-mingw32
      --with-sysroot=#{prefix}/aarch64-w64-mingw32
      --prefix=#{prefix}
      --program-prefix=aarch64-w64-mingw32-
    ]
    mkdir "mingw-w64-tools/widl/build" do
      system "../configure", *args
      system "make"
      system "make", "install"
    end

    # Finish building GCC (runtime libraries)
    chdir "#{buildpath}/gcc/build" do
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      #include <windows.h>
      int main() { puts("Hello world!");
        MessageBox(NULL, TEXT("Hello GUI!"), TEXT("HelloMsg"), 0); return 0; }
    C
    (testpath/"hello.cc").write <<~CPP
      #include <iostream>
      int main() { std::cout << "Hello, world!" << std::endl; return 0; }
    CPP
    (testpath/"hello.f90").write <<~FORTRAN
      program hello ; print *, "Hello, world!" ; end program hello
    FORTRAN
    # https://docs.microsoft.com/en-us/windows/win32/rpc/using-midl
    (testpath/"example.idl").write <<~MIDL
      [
        uuid(ba209999-0c6c-11d2-97cf-00c04f8eea45),
        version(1.0)
      ]
      interface MyInterface
      {
        const unsigned short INT_ARRAY_LEN = 100;

        void MyRemoteProc(
            [in] int param1,
            [out] int outArray[INT_ARRAY_LEN]
        );
      }
    MIDL

    ENV["LC_ALL"] = "C"
    ENV.remove_macosxsdk if OS.mac?

    system bin/"aarch64-w64-mingw32-gcc", "-o", "test.exe", "hello.c"
    assert_match "file format pei-aarch64", shell_output("#{bin}/aarch64-w64-mingw32-objdump -a test.exe")

    system bin/"aarch64-w64-mingw32-g++", "-o", "test.exe", "hello.cc"
    assert_match "file format pei-aarch64", shell_output("#{bin}/aarch64-w64-mingw32-objdump -a test.exe")

    system bin/"aarch64-w64-mingw32-gfortran", "-o", "test.exe", "hello.f90"
    assert_match "file format pei-aarch64", shell_output("#{bin}/aarch64-w64-mingw32-objdump -a test.exe")

    system bin/"aarch64-w64-mingw32-widl", "example.idl"
    assert_path_exists testpath/"example_s.c", "example_s.c should have been created"
  end
end
