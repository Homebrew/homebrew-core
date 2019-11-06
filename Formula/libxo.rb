class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/1.0.4/libxo-1.0.4.tar.gz"
  sha256 "23885980313c42211610a65004f9f319804f2ff8e94b2e83b04f4920bf45f6cb"

  bottle do
    sha256 "edf3ba21362791144880eae2e05adfa23168b6223f1f0560962a7ec6292d0f77" => :catalina
    sha256 "e9b18845d5b9fb0e5117beb87489d13f1ab387dabdfd71351e200d0283f6a3e4" => :mojave
    sha256 "aa3c710b7b134bcf40d09fe0b2b82c2115bddf2d86ab8c88e5a49e5e084b29cb" => :high_sierra
    sha256 "6de1f36c8ac26b26326393b5bf5be8d7485a72aafd1b8a6b68664c0f34025809" => :sierra
  end

  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
