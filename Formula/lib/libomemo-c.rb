class LibomemoC < Formula
  desc "Implementation of Signal's ratcheting forward secrecy protocol"
  homepage "https://github.com/dino/libomemo-c"
  url "https://github.com/dino/libomemo-c/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "d1b65dbf7bccc67523abfd5e429707f540b2532932d128b2982f0246be2b22a0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6aeea5ebef3efeaa6574535934720c669623385944ba942643c71826b54b2e09"
    sha256 cellar: :any,                 arm64_sequoia: "10b6d82f6c30e6f9434ed1655ddebda4c01cfb37e1814dc7cbf87b6dbcd683d0"
    sha256 cellar: :any,                 arm64_sonoma:  "d006d2ce0817b007a29e695a8c819a14b453ca7ec3608a10c294b4767f2279a5"
    sha256 cellar: :any,                 arm64_ventura: "c838d8370dd068a5a5ae9ea20ce6caa55de0344d35a2bdf8421b8f91c2640b8d"
    sha256 cellar: :any,                 sonoma:        "b0255f92cf0699734dcc7bc612c8d9936c0d8a49fce2626a95cb366e52c2ee51"
    sha256 cellar: :any,                 ventura:       "8cef60b4eb059781f053bc8e8f41adcfebffe647eec23a9d74d28d7af10e65d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2100e33cf8efbc544f7dc76e787b56bd2cd4d058ac36807d008bc480d9a135a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "025532b47c92f3c63c4f7dda9c99423e3f1d191f03594473d62b83150402b84b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "protobuf-c"

  def install
    args = %w[-DBUILD_SHARED_LIBS=TRUE]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    inreplace lib/"pkgconfig/libomemo-c.pc", prefix.to_s, opt_prefix.to_s
  end

  test do
    (testpath/"test.c").write <<~C
      #include <signal_protocol.h>
      #include <session_builder.h>
      #include <session_cipher.h>
      #include <stdio.h>
      #include <string.h>

      int main(void)
      {
        int result = 0;
        printf("Beginning of test...\\n");
        printf("0\\n");

        signal_context *global_context = NULL;
        result = signal_context_create(&global_context, NULL);
        if (result != SG_SUCCESS) return 1;
        printf("1\\n");

        signal_protocol_store_context *store_context = NULL;
        result = signal_protocol_store_context_create(&store_context, global_context);
        if (result != SG_SUCCESS) return 1;
        printf("2\\n");

        signal_protocol_session_store session_store = {
            NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        };
        result = signal_protocol_store_context_set_session_store(store_context, &session_store);
        if (result != SG_SUCCESS) return 1;
        printf("3\\n");

        signal_protocol_pre_key_store pre_key_store = {
            NULL, NULL, NULL, NULL, NULL, NULL
        };
        result = signal_protocol_store_context_set_pre_key_store(store_context, &pre_key_store);
        if (result != SG_SUCCESS) return 1;
        printf("4\\n");

        signal_protocol_signed_pre_key_store signed_pre_key_store = {
            NULL, NULL, NULL, NULL, NULL, NULL
        };
        result = signal_protocol_store_context_set_signed_pre_key_store(store_context, &signed_pre_key_store);
        if (result != SG_SUCCESS) return 1;
        printf("5\\n");

        signal_protocol_identity_key_store identity_key_store = {
            NULL, NULL, NULL, NULL, NULL, NULL
        };
        result = signal_protocol_store_context_set_identity_key_store(store_context, &identity_key_store);
        if (result != SG_SUCCESS) return 1;
        printf("6\\n");

        signal_protocol_address address = {
            "+14159998888", 12, 1
        };
        session_builder *builder = NULL;
        result = session_builder_create(&builder, store_context, &address, global_context);
        if (result != SG_SUCCESS) return 1;
        printf("7\\n");

        session_cipher *cipher = NULL;
        result = session_cipher_create(&cipher, store_context, &address, global_context);
        if (result != SG_SUCCESS) return 1;
        printf("8\\n");

        session_cipher_free(cipher);
        session_builder_free(builder);
        signal_protocol_store_context_destroy(store_context);
        printf("9\\n");

        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libomemo-c libprotobuf-c").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
