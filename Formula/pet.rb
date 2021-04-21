class Pet < Formula
  desc "Polyhedral Extraction Tool"
  homepage "https://pet.gforge.inria.fr/"
  url "http://pet.gforge.inria.fr/pet-0.11.5.tar.xz"
  sha256 "e9238a3e92cc13358cdec22d94c23740ac758f649df891f4bc3461e988e879e3"
  license "MIT"

  livecheck do
    url :homepage
    regex(/pet-(\d+(?:\.\d+)+b?)/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "isl"
  depends_on "libyaml"
  depends_on "llvm"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-isl=system"
    system "make"
    system "make", "install-strip"
  end

  test do
    (testpath/"test.c").write <<~EOS
      void f(const int *a, int *b);

      int foo()
      {
        int b[11];
        int a;
        int i;

      #pragma scop
        for (i = 0; i < 10; i++) {
          f(&a, &a);
          f(&b[i], &b[i+1]);
        }
      #pragma endscop

        return a;
      }
    EOS
    assert_match "domain: '{ S_1[i] : 0 <= i <= 9 }'", shell_output(bin/"pet test.c")
  end
end
