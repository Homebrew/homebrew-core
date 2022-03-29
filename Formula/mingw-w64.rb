class MingwW64 < Formula
  desc "Minimalist GNU for Windows and GCC cross-compilers"
  homepage "https://sourceforge.net/projects/mingw-w64/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v9.0.0.tar.bz2"
  sha256 "1929b94b402f5ff4d7d37a9fe88daa9cc55515a6134805c104d1794ae22a4181"
  license "ZPL-2.1"
  revision 4

  livecheck do
    url :stable
    regex(%r{url=.*?release/mingw-w64[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "f1eea4202b1b0b7748969bed806238ac841d5d1570ff00ce3fe2245409ed16f5"
    sha256 arm64_big_sur:  "a6214c5df524c79544ba307e087a428f320784b021f9007cee1621e27c0a280f"
    sha256 monterey:       "545e84678c3aafdf6642c9dfa5b6973ab37a87a2d124949c4ae51661247d0246"
    sha256 big_sur:        "3725ddb79548732bca44d523dde7a5e269f6fc5a38b0f9ff88c9dfb53f2403e3"
    sha256 catalina:       "43e8cc062d4231b937004bf12348c4ce22f838529a4c1063637fac3976d6ff31"
    sha256 x86_64_linux:   "a7869066596921d50d72f07de524c21c8837c9c5acf690f2846ac7e1c667f3c0"
  end

  # Apple's makeinfo is old and has bugs
  depends_on "texinfo" => :build

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  resource "binutils" do
    url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
    mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
    sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"

    # Fix dlltool failures during parallel builds until the release after 2.38, upstream patch
    # https://sourceware.org/bugzilla/show_bug.cgi?id=28885
    #
    # patch is from https://sourceware.org/git/?p=binutils-gdb.git;a=patch;h=d65c0ddddd85645cab6f11fd711d21638a74489f
    # with ChangeLog patch removed
    patch :DATA
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

__END__
diff --git a/binutils/dlltool.c b/binutils/dlltool.c
index d95bf3f5470..89871510b45 100644
--- a/binutils/dlltool.c
+++ b/binutils/dlltool.c
@@ -3992,10 +3992,11 @@ main (int ac, char **av)
   if (tmp_prefix == NULL)
     {
       /* If possible use a deterministic prefix.  */
-      if (dll_name)
+      if (imp_name || delayimp_name)
         {
-          tmp_prefix = xmalloc (strlen (dll_name) + 2);
-          sprintf (tmp_prefix, "%s_", dll_name);
+          const char *input = imp_name ? imp_name : delayimp_name;
+          tmp_prefix = xmalloc (strlen (input) + 2);
+          sprintf (tmp_prefix, "%s_", input);
           for (i = 0; tmp_prefix[i]; i++)
             if (!ISALNUM (tmp_prefix[i]))
               tmp_prefix[i] = '_';
