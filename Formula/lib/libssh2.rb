class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.11.1.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.11.1/libssh2-1.11.1.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.11.1.tar.gz"
  sha256 "d9ec76cbe34db98eec3539fe2c899d26b0c837cb3eb466a56b0f109cabf658f7"
  license "BSD-3-Clause"
  revision 6
  compatibility_version 1

  livecheck do
    url "https://libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8a23ccc1f7b07c2e79f31f2e64f471523627d9039ba701463b10638d6a159341"
    sha256 cellar: :any, arm64_tahoe:       "09b33a5ef8fc49fb40b27a5af6469ba25ab1b19216c8e539b291574f21215c0c"
    sha256 cellar: :any, arm64_sequoia:     "59bced956adee6dd3609cb26312dba87463b1247c38fc727bf8a92ed86b34d80"
    sha256 cellar: :any, arm64_linux:       "f1ac93bc5475de9cb16caa269273840d244419729f81c8e4719fa001e0626dea"
    sha256 cellar: :any, x86_64_linux:      "606e0b4327f89b426503de858d204c96f98dc6d48e05823a19bf906790126b8d"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/2dae3024897e1898d389835151f4e9606227721d
  # with a call to `LIBSSH2_UNCONST` removed which doesn't exist in 1.11.1.
  # This modification has been vetted and approved at https://github.com/libssh2/libssh2/issues/2125.
  # Patch can be removed with the next release.
  patch do
    file "Patches/libssh2/CVE-2025-15661.patch"
    type :backport
    resolves "CVE-2025-15661"
  end

  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/256d04b60d80bf1190e96b0ad1e91b2174d744b1.patch?full_index=1"
    sha256 "7c5fe26b0b58fb3ee3770c8a7648eddec09845fe016eff22b9074451d1a60c34"
    type :backport
    resolves "CVE-2026-7598"
  end

  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/17626857d20b3c9a1addfa45979dadcee1cd84a4.patch?full_index=1"
    sha256 "a236d5cfe1995a85c3b036ab16cc2672aa316fd3e1d6299100bcc4c07a539fd7"
    type :backport
    resolves "CVE-2026-55199"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/97acf3dfda80c91c3a8c9f2372546301d4a1a7a8
  # with a simple conflict fixed.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-55200.patch"
    type :backport
    resolves "CVE-2026-55200"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/34497525929b9a47f03dfb81887ac896202b7e12
  # with ssh2_err changed to the 1.11's _libssh2_error.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-58050.patch"
    type :backport
    resolves "CVE-2026-58050"
  end

  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/a9758da45a52bc8c630ec9493804d0c6ea30b24a.patch?full_index=1"
    sha256 "46cc7c5184d333e93c80a9cac1c86469c17340e6fc0418aecb2d0d8f6eaa5f41"
    type :backport
    resolves "CVE-2026-58051"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/5e4776146552d898b9c0e1b313cd093fa8dc92d0
  # with a simple conflict fixed.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-66032.patch"
    type :backport
    resolves "CVE-2026-66032"
  end

  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/a2ed82d40964bbc0d64cd717aa0a5a892117d2e6.patch?full_index=1"
    sha256 "378b5f95f1a410afb790c57ceb67f2d4bd15cc42fc1db58d19fe26fd6f8acbed"
    type :backport
    resolves "CVE-2026-66033"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/a13bb6c773f0d55ad1628cede57e99803cd898d9
  # with ssh2_err changed to the 1.11's _libssh2_error.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-66034.patch"
    type :backport
    resolves "CVE-2026-66034"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/42e33d81577ed4b95d4b4f6f845e5ee8efe5eeb4
  # with simple conflicts fixed and SSH2_SAFEFREE changed to the 1.11's LIBSSH2_FREE + `ptr = NULL`.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-66035.patch"
    type :backport
    resolves "CVE-2026-66035"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/631e2f82a32ef016299ebb1af66efeae0161f68e
  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/631e2f82a32ef016299ebb1af66efeae0161f68e.patch?full_index=1"
    sha256 "a790ab6c15c8dd6300ca8a651121ecc91e90e0eda1a221ad8108f51de05e1cf3"
    type :backport
    resolves "OSV-2025-90", "OSV-2025-92"
  end

  # Disable deprecated algorithms; remove with the next release containing this fix.
  patch do
    url "https://github.com/libssh2/libssh2/commit/b89858b83d68d7e29e0c5b0bb803f8a68271710c.patch?full_index=1"
    sha256 "76bdf62172e16e2f74fdde35cd3daa3db27b753c48c4a7bdfd295463444eb936"
    type :backport
    resolves "OSV-2022-24", "OSV-2024-847"
  end

  def install
    args = %W[
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{formula_opt_prefix("openssl@3")}
    ]

    system "./buildconf" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <libssh2.h>

      int main(void)
      {
          assert(libssh2_init(0) == 0);
          LIBSSH2_SESSION *session = libssh2_session_init();
          assert(session != NULL);
          int methods[] = {LIBSSH2_METHOD_CRYPT_CS, LIBSSH2_METHOD_MAC_CS};
          for(unsigned int m = 0; m < sizeof(methods) / sizeof(methods[0]); m++) {
              const char **algorithms;
              int count = libssh2_session_supported_algs(session, methods[m], &algorithms);
              assert(count > 0);
              for(int i = 0; i < count; i++)
                  puts(algorithms[i]);
              libssh2_free(session, (void *)algorithms);
          }
          assert(libssh2_session_free(session) == 0);
          libssh2_exit();
          return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    algorithms = shell_output("./test").lines.map(&:chomp)
    assert_includes algorithms, "aes256-ctr"
    assert_includes algorithms, "hmac-sha2-256"
    %w[
      arcfour arcfour128 arcfour256 3des-cbc blowfish-cbc cast128-cbc
      hmac-md5 hmac-md5-96 hmac-ripemd160 hmac-ripemd160@openssh.com
    ].each do |algorithm|
      refute_includes algorithms, algorithm
    end
  end
end
