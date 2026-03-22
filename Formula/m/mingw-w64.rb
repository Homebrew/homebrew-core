class MingwW64 < Formula
  desc "Minimalist GNU for Windows and GCC cross-compilers"
  homepage "https://sourceforge.net/projects/mingw-w64/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v13.0.0.tar.bz2"
  sha256 "5afe822af5c4edbf67daaf45eec61d538f49eef6b19524de64897c6b95828caf"
  license all_of: [
    # mingw-w64
    "ZPL-2.1",
    # binutils
    { all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"] },
    # gcc
    "GPL-3.0-or-later" => { with: "GCC-exception-3.1" },
  ]
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?release/mingw-w64[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "687705e89853f818c4750c2e254eba8ff42a6e4383776e29ad4202f54f9be2c2"
    sha256 arm64_sequoia: "20e35713fd05a9dac2fcda9e0c56468c539526825b19dee23f1f5625992cb28c"
    sha256 arm64_sonoma:  "a891e793e7b40feed8fcf1aac63e2386d754efcbf2df927b6bd526a2d6ddaf13"
    sha256 sonoma:        "07abc35bcfcf64297df6a8bb50a587148921b2618f94aec95ba9da370fa17222"
    sha256 arm64_linux:   "d51e6d1a3acc70fe646a710fe8d9a0a4d672ddf0f23087c0ca5b25e5a176480b"
    sha256 x86_64_linux:  "b483173565e227feb70a894630749d8538de3067672ac00786c2612d0c8824cd"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "binutils" do
    url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
    sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  end

  resource "gcc" do
    url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
    sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
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
          --with-system-zlib
          --with-zstd
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
        --enable-languages=c,c++,objc,obj-c++,fortran
        --with-ld=#{arch_dir}/bin/#{target}-ld
        --with-as=#{arch_dir}/bin/#{target}-as
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
    target_archs.each do |arch|
      target = "#{arch}-w64-mingw32"
      outarch = (arch == "i686") ? "i386" : "x86-64"

      system bin/"#{target}-gcc", "-o", "test.exe", "hello.c"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system bin/"#{target}-g++", "-o", "test.exe", "hello.cc"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system bin/"#{target}-gfortran", "-o", "test.exe", "hello.f90"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system bin/"#{target}-widl", "example.idl"
      assert_path_exists testpath/"example_s.c", "example_s.c should have been created"
    end
  end
end
