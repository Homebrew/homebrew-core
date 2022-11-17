class MingwW64 < Formula
  desc "Minimalist GNU for Windows and GCC cross-compilers"
  homepage "https://sourceforge.net/projects/mingw-w64/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v10.0.0.tar.bz2"
  sha256 "ba6b430aed72c63a3768531f6a3ffc2b0fde2c57a3b251450dcf489a894f0894"
  license "ZPL-2.1"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?release/mingw-w64[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "e11fe4948e53777d4c0c39b91ccea20c02c53a9ecd19df2cfb48f4016cceab9f"
    sha256 arm64_monterey: "a93b02724538ddab682de97fb5954af51a777277ff60ca0c05cb09e98114c6bf"
    sha256 arm64_big_sur:  "f7c7a35d27f4543226adab2d8b984eb464dd854c8a49bd38840c66e6a33583fb"
    sha256 ventura:        "2fd716e859661d089b5721c0af0069d6dbff9a66f38b7ddcbe65188a0a344bb2"
    sha256 monterey:       "410a717fc0c81aabc961058b79411de9ab538c8ca61dd13262787c776f542c1f"
    sha256 big_sur:        "0ad8f84cfce32fee78aa28bcc78f17184affb786c733be96040ae8b1c81c5bab"
    sha256 catalina:       "197f1eab5e40be9b76a473b9b34c479d4c7c48f0a4e1b642a6bc13375607c1b5"
    sha256 x86_64_linux:   "2adcbf1dba5615b4778a73345ca5c37346f902fa3cf06681ba0e765e101cf3b8"
  end

  # Apple's makeinfo is old and has bugs
  depends_on "texinfo" => :build

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  resource "binutils" do
    url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
    mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
    sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  end

  resource "gcc" do
    url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
    sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
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
          --with-sysroot=#{arch_dir}
          --prefix=#{arch_dir}
          --enable-targets=#{target}
          --disable-multilib
          --disable-nls
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
        --with-sysroot=#{arch_dir}
        --prefix=#{arch_dir}
        --with-bugurl=#{tap.issues_url}
        --enable-languages=c,c++,fortran
        --with-ld=#{arch_dir}/bin/#{target}-ld
        --with-as=#{arch_dir}/bin/#{target}-as
        --with-gmp=#{Formula["gmp"].opt_prefix}
        --with-mpfr=#{Formula["mpfr"].opt_prefix}
        --with-mpc=#{Formula["libmpc"].opt_prefix}
        --with-isl=#{Formula["isl"].opt_prefix}
        --with-zstd=no
        --disable-multilib
        --disable-nls
        --enable-threads=posix
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
        --with-sysroot=#{arch_dir}/#{target}
        --prefix=#{arch_dir}/#{target}
      ]

      case arch
      when "i686"
        args << "--enable-lib32" << "--disable-lib64"
      when "x86_64"
        args << "--disable-lib32" << "--enable-lib64"
      end

      mkdir "mingw-w64-crt/build-#{arch}" do
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
        CC=#{target}-gcc
        CXX=#{target}-g++
        CPP=#{target}-cpp
        --host=#{target}
        --with-sysroot=#{arch_dir}/#{target}
        --prefix=#{arch_dir}/#{target}
      ]
      mkdir "mingw-w64-libraries/winpthreads/build-#{arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      args = %W[
        --host=#{target}
        --with-sysroot=#{arch_dir}/#{target}
        --prefix=#{arch_dir}
        --program-prefix=#{target}-
      ]
      mkdir "mingw-w64-tools/widl/build-#{arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      # Finish building GCC (runtime libraries)
      chdir "#{buildpath}/gcc/build-#{arch}" do
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
    # https://docs.microsoft.com/en-us/windows/win32/rpc/using-midl
    (testpath/"example.idl").write <<~EOS
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
    EOS

    ENV["LC_ALL"] = "C"
    ENV.remove_macosxsdk if OS.mac?
    target_archs.each do |arch|
      target = "#{arch}-w64-mingw32"
      outarch = (arch == "i686") ? "i386" : "x86-64"

      system "#{bin}/#{target}-gcc", "-o", "test.exe", "hello.c"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system "#{bin}/#{target}-g++", "-o", "test.exe", "hello.cc"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system "#{bin}/#{target}-gfortran", "-o", "test.exe", "hello.f90"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system "#{bin}/#{target}-widl", "example.idl"
      assert_predicate testpath/"example_s.c", :exist?, "example_s.c should have been created"
    end
  end
end
