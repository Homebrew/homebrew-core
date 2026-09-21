class GssNtlmssp < Formula
  desc "NTLM authentication plugin for GSSAPI"
  homepage "https://github.com/gssapi/gss-ntlmssp"
  url "https://github.com/gssapi/gss-ntlmssp/releases/download/v1.3.2/gssntlmssp-1.3.2.tar.gz"
  sha256 "e5cc8d74e5f88cfe74622b14d1d28e85710dec898b754c2c78969f25147bbb55"
  license "ISC"
  head "https://github.com/gssapi/gss-ntlmssp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "cc7534e45f967a33fcd580f9dd667ec663d383a9a4f485576949c33fb26bdc44"
    sha256 cellar: :any, x86_64_linux: "8484e1f1db394de0e244a2becb5f3cca13fe0df9b6cae80e6dcc5485bc298522"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "krb5"
  depends_on "libunistring"
  depends_on :linux
  depends_on "openssl@3"
  depends_on "zlib-ng-compat"

  def install
    system "./configure", "--disable-static",
                          "--without-wbclient",
                          "--without-manpages",
                          *std_configure_args
    system "make", "install"

    # Install the GSSAPI mechanism configuration file
    (etc/"gss/mech.d").install "examples/mech.ntlmssp" => "ntlmssp.conf"
  end

  test do
    # Verify the mechanism config is installed with the correct library path
    conf = (etc/"gss/mech.d/ntlmssp.conf").read
    assert_match "gssntlmssp", conf
    assert_match lib.to_s, conf

    # Verify the shared library can be dlopened
    (testpath/"test.c").write <<~C
      #include <dlfcn.h>
      #include <stdio.h>
      int main() {
        void *handle = dlopen("#{lib}/gssntlmssp/gssntlmssp.so", RTLD_NOW);
        if (!handle) {
          fprintf(stderr, "dlopen: %s\\n", dlerror());
          return 1;
        }
        dlclose(handle);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-ldl"
    system "./test"
  end
end
