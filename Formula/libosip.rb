class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.2.1.tar.gz"
  sha256 "ee3784bc8e7774f56ecd0e2ca6e3e11d38b373435115baf1f1aa0ca0bfd02bf2"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/href=.*?libosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "768aa5e4a093d9117ca588d4b7796b3a31c6ba88a463f8647dd3698b70e2a951"
    sha256 cellar: :any, big_sur:       "8f5c5fdfede2252824de6af7f2119dc78a95533c79ca0862d986c98bb3015f6f"
    sha256 cellar: :any, catalina:      "c23d056597896c51c2f364b06b7843c2998931429cefaa5413aa05e57fedef9c"
    sha256 cellar: :any, mojave:        "d1f91870b64ffd2b286d76ee44af1f1f7bd94749141110cbfd5de8d327a72e40"
    sha256 cellar: :any, high_sierra:   "d1241b9bbcbacff0a2823b3d1a96ebeb36bc3176b8f18542b9a1cf595900c94f"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/time.h>
      #include <osip2/osip.h>

      int main() {
          osip_t *osip;
          int i = osip_init(&osip);
          if (i != 0)
            return -1;
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-losip2", "-o", "test"
    system "./test"
  end
end
