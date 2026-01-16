class Libnsl < Formula
  desc "Public client interface for NIS(YP) and NIS+"
  homepage "https://github.com/thkukuk/libnsl"
  url "https://github.com/thkukuk/libnsl/releases/download/v2.0.1/libnsl-2.0.1.tar.xz"
  sha256 "5c9e470b232a7acd3433491ac5221b4832f0c71318618dc6aa04dd05ffcd8fd9"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b5f2c97b5782dfde6d350ebe54cacf87db18a1626afcf91998aaa8d6c5930890"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa7613b30e9bfe15166339d119c19115ec21f13cea259280182e0c083502ff40"
  end

  depends_on "pkgconf" => :build
  depends_on "libtirpc"
  depends_on :linux

  link_overwrite "include/rpcsvc"
  link_overwrite "lib/libnsl.a"
  link_overwrite "lib/libnsl.so"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <rpcsvc/ypclnt.h>

      int main(int argc, char *argv[]) {
         char *domain;
         switch (yp_get_default_domain(&domain)) {
         case YPERR_SUCCESS:
           printf("Domain: %s\n", domain);
           return 0;
         case YPERR_NODOM:
           printf("No domain\n");
           return 0;
         default:
           return 1;
         }
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnsl", "-o", "test"

    domain = Utils.popen_read("ypdomainname").chomp
    domain_exists = $CHILD_STATUS.success?

    output = shell_output("./test").chomp
    if domain_exists
      assert_equal "Domain: #{domain}", output
    else
      assert_equal "No domain", output
    end
  end
end
