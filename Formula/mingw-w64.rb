class MingwW64 < Formula
  desc "Minimalist GNU for Windows and GCC cross-compilers"
  homepage "https://mingw-w64.org/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.2.tar.bz2"
  sha256 "5f46e80ff1a9102a37a3453743dae9df98262cba7c45306549ef7432cfd92cfd"
  revision 2

  bottle do
    sha256 "cfb4d2192a11632bcc524442fef27736457d6b297119b438b2e279b86dfa58be" => :sierra
    sha256 "3955319b438d08eff5a0f3ba4829bb3c3138950edb851c07d273f9cb3eef0a99" => :el_capitan
    sha256 "f26c3db40dc96f34fd68107ce589a0288a9b00ba8768267f413ac62961f963ed" => :yosemite
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "isl"

  # Apple's makeinfo is old and has bugs
  depends_on "texinfo" => :build

  resource "binutils" do
    url "https://ftp.gnu.org/gnu/binutils/binutils-2.29.tar.gz"
    mirror "https://ftpmirror.gnu.org/binutils/binutils-2.29.tar.gz"
    sha256 "172e8c89472cf52712fd23a9f14e9bca6182727fb45b0f8f482652a83d5a11b4"
  end

  resource "gcc" do
    url "https://ftp.gnu.org/gnu/gcc/gcc-7.1.0/gcc-7.1.0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-7.1.0/gcc-7.1.0.tar.bz2"
    sha256 "8a8136c235f64c6fef69cac0d73a46a1a09bb250776a050aec8f9fc880bebc17"
  end

  # Patch for mingw-w64 5.0.2 with GCC 7
  # https://sourceforge.net/p/mingw-w64/mingw-w64/ci/431ac2a912708546cd7271332e9331399e66bc62/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/549c05c1f4/mingw-w64/divmoddi4.patch"
    sha256 "a8323a12b25baec1335e617111effc9236b48ce1162a63c4898bf6be12680c42"
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
    (testpath/"hello.c").write <<-EOS.undent
      #include <stdio.h>
      #include <windows.h>
      int main() { puts("Hello world!");
        MessageBox(NULL, TEXT("Hello GUI!"), TEXT("HelloMsg"), 0); return 0; }
    EOS
    (testpath/"hello.cc").write <<-EOS.undent
      #include <iostream>
      int main() { std::cout << "Hello, world!" << std::endl; return 0; }
    EOS
    (testpath/"hello.f90").write <<-EOS.undent
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
