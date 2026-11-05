class OpensshSkProvider < Formula
  desc "Standalone FIDO2 SecurityKeyProvider (sk-libfido2) for the system OpenSSH"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.6p2.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.6p2.tar.gz"
  version "10.6p2"
  sha256 "9ae44872090cf2f06b3cf9ff147e7f16f309671340763ed2f99248398ae29d5b"
  license "SSH-OpenSSH"

  livecheck do
    formula "openssh"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f5f0656e1d28632f13bfb50f301fb50f9c136ad67b87f6019e52a3dcc38a6f7a"
    sha256 cellar: :any, arm64_tahoe:       "f1538f9358742839330d30ef24ea2b09c68f845d9af9beab2f10ffdf12adbd1a"
    sha256 cellar: :any, arm64_sequoia:     "fed576807104e97d1510209c4f8f824bd637c2bbdf2874d1a2569d67f1e75ddd"
  end

  head do
    url "https://github.com/openssh/openssh-portable.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on :macos
  depends_on "openssl@4"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--with-ssl-dir=#{formula_opt_prefix("openssl@4")}",
                          "--with-security-key-standalone",
                          *std_configure_args
    # Only export the SecurityKeyProvider API, not the bundled libssh/openbsd-compat symbols
    inreplace "Makefile", "-DSK_STANDALONE $(PICFLAG)",
                          "-DSK_STANDALONE $(PICFLAG) -Wl,-dead_strip,-exported_symbol,'_sk_*'"
    system "make", "sk-libfido2.dylib"
    lib.install "sk-libfido2.dylib"
  end

  def caveats
    <<~EOS
      To make the system ssh use this provider, add to the `Host *` block in ~/.ssh/config:
        SecurityKeyProvider #{opt_lib}/sk-libfido2.dylib

      ssh-keygen and ssh-add don't read ~/.ssh/config, so also add to your shell profile:
        export SSH_SK_PROVIDER="#{opt_lib}/sk-libfido2.dylib"

      The system ssh-agent only allows providers under /usr/lib and /usr/local/lib, so it
      won't hold keys that use this provider. To use an agent, run your own with e.g.:
        ssh-agent -P "#{HOMEBREW_CELLAR}/#{name}/*/lib/*"
    EOS
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dlfcn.h>
      #include <stdint.h>
      #include <stdio.h>

      int main(void) {
        void *h = dlopen("#{lib}/sk-libfido2.dylib", RTLD_NOW);
        if (h == NULL) { fprintf(stderr, "%s\\n", dlerror()); return 1; }
        uint32_t (*sk_api_version)(void) = (uint32_t (*)(void))dlsym(h, "sk_api_version");
        if (sk_api_version == NULL) return 1;
        printf("0x%08x\\n", sk_api_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    assert_match(/^0x[0-9a-f]{8}$/, shell_output("./test"))

    exported = shell_output("nm -gU #{lib}/sk-libfido2.dylib").lines.map { |line| line.split.last }
    assert_equal %w[_sk_api_version _sk_enroll _sk_load_resident_keys _sk_sign], exported.sort
  end
end
