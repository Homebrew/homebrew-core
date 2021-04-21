class Ppcg < Formula
  desc "Polyhedral Parallel Code Generation"
  homepage "https://ppcg.gforge.inria.fr/"
  url "http://ppcg.gforge.inria.fr/ppcg-0.08.5.tar.bz2"
  sha256 "a9405f7f086591fa6abd596bb3a9f1fa0f7e05aca420fcd13afc1fc0077307d7"
  license "MIT"

  livecheck do
    url :homepage
    regex(/ppcg-(\d+(?:\.\d+)+b?)/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "isl"
  depends_on "libyaml"
  depends_on "pet"

  def install
    ENV["PET_CFLAGS"] = "-I#{Formula["pet"].opt_include}"
    ENV["PET_LIBS"] = "-L#{Formula["pet"].opt_lib} -lpet"

    system "./configure", "--prefix=#{prefix}", "--with-isl=system", "--with-pet=system"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ppcg", "--version"

    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>

      void copy_summary(int b[100], int a[100], int pos)
      {
        b[pos] = 0;
        int c = a[pos];
      }

      void copy(int b[100], int a[100], int pos);

      int main()
      {
        int a[100], b[100];

        for (int i = 0; i < 100; ++i)
          a[i] = i;
      #pragma scop
        for (int i = 0; i < 100; ++i)
          copy(b, a, i);
      #pragma endscop
        for (int i = 0; i < 100; ++i)
          if (b[i] != a[i])
            return EXIT_FAILURE;

        return EXIT_SUCCESS;
      }
    EOS
    system bin/"ppcg", "test.c"
    %w[
      test_host.cu
      test_kernel.cu
      test_kernel.hu
    ].each { |f| assert_predicate testpath/f, :exist? }
  end
end
