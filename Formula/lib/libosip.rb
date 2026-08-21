class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftpmirror.gnu.org/gnu/osip/libosip2-5.3.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/osip/libosip2-5.3.2.tar.gz"
  sha256 "16186f6f5540936b62c3aaca6e8409e1af25cd22abc3882b393be215f49d3b00"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/href=.*?libosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa6e209abf2fea8b98ef971e6949687633f724bff1b09d653c2ea719bb1d106a"
    sha256 cellar: :any, arm64_sequoia: "50904acb0a787d93d0f05a683b4dce7a5b10787ff2e4b657af414614ce1cbe0a"
    sha256 cellar: :any, arm64_sonoma:  "a1c3d36a7177ba59a74a7e716301edd0e4b886db07d8b011401d941745eddee9"
    sha256 cellar: :any, sonoma:        "4eb6cc94e3aa2f2029d73e871249314114468c21815ad7a25e60631740a1ace2"
    sha256 cellar: :any, arm64_linux:   "abbfbca39010cee9c5ffcf1cd7cc72c501449036ee39ae8d203a35f826541710"
    sha256 cellar: :any, x86_64_linux:  "c81d067b9c0e9c096860ecc6a5fc8ec3cbaef2eaa69f03a76c9f370575c9dcdc"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sys/time.h>
      #include <osip2/osip.h>

      int main() {
          osip_t *osip;
          int i = osip_init(&osip);
          if (i != 0)
            return -1;
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-losip2", "-o", "test"
    system "./test"
  end
end
