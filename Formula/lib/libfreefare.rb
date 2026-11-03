class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://github.com/nfc-tools/libfreefare"
  url "https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-0.4.0/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "48352143ce917eaff9a274b3cee3fc577c979499ffb33cb84bc38cbe9c09c65a"
    sha256 cellar: :any, arm64_tahoe:       "31739c64def98786772cde5e4beb73baec881f6728e43de69be29e1f69473a5f"
    sha256 cellar: :any, arm64_sequoia:     "96edea38dd2aed66c6a60e72e31ac575ca66363d765cca646cfbbffd77787cc0"
    sha256 cellar: :any, arm64_linux:       "23ea0557012764a0d818be457e8b260330f3a5edf217aa39a9cbe2545ebcca18"
    sha256 cellar: :any, x86_64_linux:      "ebe02580028a909396a60c07c7a3a0d3cd55e26ecc0ad8c9694b7dc8861988d4"
  end

  depends_on "pkgconf" => :build
  depends_on "libnfc"
  depends_on "openssl@4"

  on_macos do
    depends_on "libusb-compat"
  end

  # Upstream commit for endianness-related functions
  patch do
    url "https://github.com/nfc-tools/libfreefare/commit/358df775.patch?full_index=1"
    sha256 "20d592c11e559d0a5f02f7ed56da370e39439feebd971be11b064d58ea85777f"
    type :backport
    resolves "https://github.com/nfc-tools/libfreefare/pull/56",
             "https://github.com/nfc-tools/libfreefare/issues/55"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    ENV.append_to_cflags "-I#{formula_opt_include(openssl)}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib(openssl)}"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <freefare.h>
      int main() {
        mifare_desfire_aid_new(0);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lfreefare", "-o", "test"
    system "./test"
  end
end
