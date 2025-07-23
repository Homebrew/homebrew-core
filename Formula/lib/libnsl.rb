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

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libtirpc"

  link_overwrite "include/rpcsvc"
  link_overwrite "lib/libnsl.a"
  link_overwrite "lib/libnsl.so"

  # patch to support macos build, upstream pr ref, https://github.com/thkukuk/libnsl/pull/24
  patch do
    url "https://github.com/thkukuk/libnsl/commit/db614c41660fc8c06f7c4a40dd36cd82feb471d5.patch?full_index=1"
    sha256 "60f4098fcb5d97fc2158e805ed8fe5936d50bfb6af57cab54a281fd9d8677b62"
  end

  def install
    odie "check if autoreconf line can be removed" if version > "2.0.1"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules", *std_configure_args
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
