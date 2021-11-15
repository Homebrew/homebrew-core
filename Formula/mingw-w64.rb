class MingwW64 < Formula
  desc "Minimalist GNU for Windows and GCC cross-compilers"
  homepage "https://sourceforge.net/projects/mingw-w64/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v9.0.0.tar.bz2"
  sha256 "1929b94b402f5ff4d7d37a9fe88daa9cc55515a6134805c104d1794ae22a4181"
  license "ZPL-2.1"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?release/mingw-w64[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "7671527ea0a57310de4c8f367fa0cdfb3ea6f268c243466933df21a8f719e12d"
    sha256 arm64_big_sur:  "6a226bcd216aa4689fb1426c3459caeaa7ee6a2403276c124956f222e9bdc6c9"
    sha256 monterey:       "7454839c73ded2b9bdd7914df7d013f93afb760ec2175d299473954dc45e70a3"
    sha256 big_sur:        "0a48943bac581260148704b796a27aafc21d7650a0dd7b60c9d64dbec148be93"
    sha256 catalina:       "780144a43e99c22058a07d76668e83107a2bb5e89b651d694c1756174ca65ca3"
    sha256 mojave:         "55243318eb8179bb7f962c83cb0a35a03fa728e9e444848f4948e82f4e0039c8"
    sha256 x86_64_linux:   "0976e76105c70de683c1f4f2283248bf70521858d3bd91737e0e6bd01099af17"
  end

  # Apple's makeinfo is old and has bugs
  depends_on "texinfo" => :build

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  resource "binutils" do
    url "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"
    mirror "https://ftpmirror.gnu.org/binutils/binutils-2.37.tar.xz"
    sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
  end

  resource "gcc" do
    url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
    sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"

    # Remove when upstream has Apple Silicon support
    if Hardware::CPU.arm?
      patch do
        # patch from gcc-11.1.0-arm branch
        url "https://github.com/fxcoudert/gcc/commit/eea3046c5fa62d4dee47e074c7a758570d9da61c.patch?full_index=1"
        sha256 "b55ca05a0ed32f69f63bbe708568df5ad62d938da0e34b515d601bb966d32d40"
      end
    end
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
    on_macos do
      ENV.remove_macosxsdk
    end
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
