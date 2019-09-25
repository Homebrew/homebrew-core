class LibsignalProtocolC < Formula
  desc "Signal Protocol C Library"
  homepage "https://github.com/signalapp/libsignal-protocol-c"
  url "https://github.com/signalapp/libsignal-protocol-c/archive/v2.3.2.tar.gz"
  sha256 "f3826f3045352e14027611c95449bfcfe39bfd3d093d578c70f70eee0c85000d"
  revision 1

  bottle do
    cellar :any
    sha256 "7035841cf73621a131ee048066d83c8bc76603b87169849f88ce465244673540" => :mojave
    sha256 "1d81242623d2f2ed761f324dee57a5604ec9fb70cc8ac7c604c92619f93010c2" => :high_sierra
    sha256 "777f53a6b2b73a010e602f29d0d67f43cc5aa100db82629c66b17ee9b79fc830" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}/signal",
                   "-L#{lib}", "-lsignal-protocol-c",
                   "-o", "test"
    system "./test"
  end
end
