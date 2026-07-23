class GssNtlmssp < Formula
  desc "NTLM authentication plugin for GSSAPI"
  homepage "https://github.com/gssapi/gss-ntlmssp"
  url "https://github.com/gssapi/gss-ntlmssp/releases/download/v1.3.1/gssntlmssp-1.3.1.tar.gz"
  sha256 "eb87b4c2c1137959025b355296fa556b4d5a09c480e75918ee4b13c354eae29d"
  license "ISC"
  head "https://github.com/gssapi/gss-ntlmssp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "e86ca4dcbe5d70c868f9c7b8739ef8a2e0944825dd6e66972a74f74a3d03a030"
    sha256 cellar: :any, x86_64_linux: "d68f43184a27e73931f39e7843df728ba6d6663c2b6d43c4278deecf08b9a78d"
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
