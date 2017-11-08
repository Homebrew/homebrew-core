class MingwW64 < Formula
  desc "Minimalist GNU for Windows and GCC cross-compilers"
  homepage "https://mingw-w64.org/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.3.tar.bz2"
  sha256 "2a601db99ef579b9be69c775218ad956a24a09d7dabc9ff6c5bd60da9ccc9cb4"

  bottle do
    sha256 "aaeaf080ee7ab0f27333db8a1826bd1ba6c56cea0b9222fb0f005a8c67a7fa8b" => :high_sierra
    sha256 "59c6a9805b9465536ea75193729c709c23bc23748e7c7354c004eba76b1f26cf" => :sierra
    sha256 "0b51651bf82d7fef7b0a2e90b7b4956babe907d8781a02b3b3e0a80e5597e71c" => :el_capitan
    sha256 "a5adac170ecbfe2e24e68a43e3ae0f2974bc5f67443ddd15bbbf6c7d6a92d7a4" => :yosemite
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "isl"

  # Apple's makeinfo is old and has bugs
  depends_on "texinfo" => :build

  resource "binutils" do
    url "https://ftp.gnu.org/gnu/binutils/binutils-2.29.1.tar.gz"
    mirror "https://ftpmirror.gnu.org/binutils/binutils-2.29.1.tar.gz"
    sha256 "0d9d2bbf71e17903f26a676e7fba7c200e581c84b8f2f43e72d875d0e638771c"
  end

  resource "gcc" do
    url "https://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz"
    sha256 "1cf7adf8ff4b5aa49041c8734bbcf1ad18cc4c94d0029aae0f4e48841088479a"
  end

  def target_archs
    ["i686", "x86_64"].freeze
  end

  def install
    target_archs.each do |arch|
      arch_dir = "#{prefix}/toolchain-#{arch}"
      target = "#{arch}-w64-mingw32"

      resource("binutils").stage do
        args = %W[
          --target=#{target}
          --prefix=#{arch_dir}
          --enable-targets=#{target}
          --disable-multilib
        ]
        mkdir "build-#{arch}" do
          system "../configure", *args
          system "make"
          system "make", "install"
        end
      end

      # Put the newly built binutils into our PATH
      ENV.prepend_path "PATH", "#{arch_dir}/bin"

      mkdir "mingw-w64-headers/build-#{arch}" do
        system "../configure", "--host=#{target}", "--prefix=#{arch_dir}/#{target}"
        system "make"
        system "make", "install"
      end

      # Create a mingw symlink, expected by GCC
      ln_s "#{arch_dir}/#{target}", "#{arch_dir}/mingw"

      # Build the GCC compiler
      resource("gcc").stage buildpath/"gcc"
      args = %W[
        --target=#{target}
        --prefix=#{arch_dir}
        --with-bugurl=https://github.com/Homebrew/homebrew-core/issues
        --enable-languages=c,c++,fortran
        --with-ld=#{arch_dir}/bin/#{target}-ld
        --with-as=#{arch_dir}/bin/#{target}-as
        --with-gmp=#{Formula["gmp"].opt_prefix}
        --with-mpfr=#{Formula["mpfr"].opt_prefix}
        --with-mpc=#{Formula["libmpc"].opt_prefix}
        --with-isl=#{Formula["isl"].opt_prefix}
        --disable-multilib
      ]

      mkdir "#{buildpath}/gcc/build-#{arch}" do
        system "../configure", *args
        system "make", "all-gcc"
        system "make", "install-gcc"
      end

      # Build the mingw-w64 runtime
      args = %W[
        CC=#{target}-gcc
        CXX=#{target}-g++
        CPP=#{target}-cpp
        --host=#{target}
        --prefix=#{arch_dir}/#{target}
      ]

      if arch == "i686"
        args << "--enable-lib32" << "--disable-lib64"
      elsif arch == "x86_64"
        args << "--disable-lib32" << "--enable-lib64"
      end

      mkdir "mingw-w64-crt/build-#{arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      # Finish building GCC (runtime libraries)
      chdir "#{buildpath}/gcc/build-#{arch}" do
        system "make"
        system "make", "install"
      end

      # Build the winpthreads library
      args = %W[
        CC=#{target}-gcc
        CXX=#{target}-g++
        CPP=#{target}-cpp
        --host=#{target}
        --prefix=#{arch_dir}/#{target}
      ]
      mkdir "mingw-w64-libraries/winpthreads/build-#{arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      # Symlinks all binaries into place
      mkdir_p bin
      Dir["#{arch_dir}/bin/*"].each { |f| ln_s f, bin }
    end
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      #include <windows.h>
      int main() { puts("Hello world!");
        MessageBox(NULL, TEXT("Hello GUI!"), TEXT("HelloMsg"), 0); return 0; }
    EOS
    (testpath/"hello.cc").write <<~EOS
      #include <iostream>
      int main() { std::cout << "Hello, world!" << std::endl; return 0; }
    EOS
    (testpath/"hello.f90").write <<~EOS
      program hello ; print *, "Hello, world!" ; end program hello
    EOS

    ENV["LC_ALL"] = "C"
    target_archs.each do |arch|
      target = "#{arch}-w64-mingw32"
      outarch = (arch == "i686") ? "i386" : "x86-64"

      system "#{bin}/#{target}-gcc", "-o", "test.exe", "hello.c"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system "#{bin}/#{target}-g++", "-o", "test.exe", "hello.cc"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system "#{bin}/#{target}-gfortran", "-o", "test.exe", "hello.f90"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")
    end
  end
end
