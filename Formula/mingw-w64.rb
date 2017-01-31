class MingwW64 < Formula
  desc "Minimalist GNU for Windows with GCC."
  homepage "https://mingw-w64.org/"
  # https://sourceforge.net/p/mingw-w64/wiki2/Cross%20Win32%20and%20Win64%20compiler/
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.1.tar.bz2"
  sha256 "9bb5cd7df78817377841a63555e73596dc0af4acbb71b09bd48de7cf24aeadd2"

  # option "with-multilib", "Compile x86_64 compiler with multilib support"

  depends_on "texinfo" => :build
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "isl"
  depends_on "gmp"

  resource "binutils" do
    url "https://ftpmirror.gnu.org/binutils/binutils-2.27.tar.gz"
    sha256 "26253bf0f360ceeba1d9ab6965c57c6a48a01a8343382130d1ed47c468a3094f"
  end

  resource "gcc" do
    url "https://ftpmirror.gnu.org/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2"
    sha256 "f06ae7f3f790fbf0f018f6d40e844451e6bc3b7bc96e128e63b09825c1f8b29f"
  end

  def target_archs
    { "i686-w64-mingw32" => "i386", "x86_64-w64-mingw32" => "x86-64" }.freeze
  end

  def install
    target_archs.keys.each do |target_arch|
      resource("binutils").stage do
        args = %W[
          --target=#{target_arch}
          --prefix=#{prefix}
          --with-sysroot=#{prefix}
        ]
        if target_arch.start_with?("i686") || (target_arch.start_with?("x86_64") && build.without?("multilib"))
          args << "--enable-targets=#{target_arch}" << "--disable-multilib"
        elsif target_arch.start_with?("x86_64") && build.with?("multilib")
          args << "--enable-targets=#{target_archs.keys.join(",")}"
        end
        mkdir "build-#{target_arch}" do
          system "../configure", *args
          system "make"
          system "make", "install"
        end
        info.rmtree
        (share/"locale").rmtree
      end
      ENV.prepend_path "PATH", bin.to_s

      args = %W[
        --host=#{target_arch}
        --prefix=#{prefix}/#{target_arch}
      ]
      args << "--disable-multilib" if target_arch.start_with?("i686") || (target_arch.start_with?("x86_64") && build.without?("multilib"))

      mkdir "mingw-w64-headers/build-#{target_arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      ln_s "#{prefix}/#{target_arch}", "#{prefix}/mingw"

      resource("gcc").stage buildpath/"gcc"

      gcc_args = %W[
        --target=#{target_arch}
        --prefix=#{prefix}
        --with-sysroot=#{prefix}
        --enable-version-specific-runtime-libs
        --with-bugurl=https://github.com/Homebrew/homebrew-core/issues
        --enable-languages=c,c++,fortran
        --with-ld=#{bin}/#{target_arch}-ld
        --with-as=#{bin}/#{target_arch}-as
        --with-gmp=#{Formula["gmp"].opt_prefix}
        --with-mpfr=#{Formula["mpfr"].opt_prefix}
        --with-mpc=#{Formula["libmpc"].opt_prefix}
        --with-isl=#{Formula["isl"].opt_prefix}
      ]
      if target_arch.start_with?("i686")
        gcc_args << "--disable-multilib"
      elsif target_arch.start_with?("x86_64") && build.without?("multilib")
        gcc_args << "--enable-64bit" << "--disable-multilib"
      elsif target_arch.start_with?("x86_64") && build.with?("multilib")
        gcc_args << "--enable-targets=all"
      end

      mkdir "#{buildpath}/gcc/build-#{target_arch}" do
        system "../configure", *gcc_args
        system "make", "all-gcc"
        system "make", "install-gcc"
      end

      ENV.prepend_path "PATH", bin.to_s

      args = %W[
        CC=#{target_arch}-gcc
        CXX=#{target_arch}-g++
        CPP=#{target_arch}-cpp
        LD=#{target_arch}-gcc
        --host=#{target_arch}
        --prefix=#{prefix}/#{target_arch}
        --with-sysroot=#{prefix}/#{target_arch}
      ]

      if target_arch.start_with?("i686")
        args << "--enable-lib32" << "--disable-lib64"
      elsif target_arch.start_with?("x86_64") && build.without?("multilib")
        args << "--disable-lib32" << "--enable-lib64"
      elsif target_arch.start_with?("x86_64") && build.with?("multilib")
        args << "--enable-lib32" << "--enable-lib64"
      end

      mkdir "mingw-w64-crt/build-#{target_arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      chdir "#{buildpath}/gcc/build-#{target_arch}" do
        system "make"
        system "make", "install"
      end

      ln_s "../../lib/gcc/#{target_arch}/lib/libgcc_s.a", "#{prefix}/#{target_arch}/lib"

      ENV["LDPATH"] = "#{target_arch}/#{lib}"
      args = %W[
        CC=#{target_arch}-gcc
        CXX=#{target_arch}-g++
        CPP=#{target_arch}-cpp
        --host=#{target_arch}
        --prefix=#{prefix}/#{target_arch}
      ]

      mkdir "mingw-w64-libraries/winpthreads/build-#{target_arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
      puts("Hello, world!");
      return 0;
      }
      EOS
    (testpath/"hello-win.c").write <<-EOS.undent
      #include <stdio.h>
      #include <windows.h>
      int main (void)
      {
      fprintf (stdout, "Hello, console!");
      MessageBox (NULL, TEXT("Hello, GUI!"), TEXT("HelloMsg"), 0);
      exit (EXIT_SUCCESS);
      }
      EOS
    (testpath/"hello.cc").write <<-EOS.undent
      #include <iostream>
      int main()
      {
      std::cout << "Hello, world!" << std::endl;
      return 0;
      }
      EOS
    (testpath/"hello.f90").write <<-EOS.undent
      program hello
      print *, "Hello, world!"
      end program hello
      EOS
    compiler = { ".c" => "gcc", ".cc" => "g++", ".f90" => "gfortran" }.freeze
    target_archs.keys.each do |target_arch|
      Dir["hello*{#{compiler.keys.join(",")}}"].each do |src|
        exe = "#{target_arch}-#{src.tr(".", "-")}.exe"
        system "#{bin}/#{target_arch}-#{compiler[File.extname(src)]}", "-o", exe, src
        assert_match "file format pei-#{target_archs[target_arch]}", shell_output("#{bin}/#{target_arch}-objdump -a #{exe}")
        end
      end
    end
  end
end
