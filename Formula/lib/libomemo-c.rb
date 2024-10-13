class LibomemoC < Formula
  desc "Implementation of Signal's ratcheting forward secrecy protocol"
  homepage "https://github.com/dino/libomemo-c"
  url "https://github.com/dino/libomemo-c/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "03195a24ef7a86c339cdf9069d7f7569ed511feaf55e853bfcb797d2698ba983"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "706625428f96e1a3a56e49b9841d19ee1e7f64b197bbdcdc50135c40e80be326"
    sha256 cellar: :any,                 arm64_sonoma:   "73f2267cfaa0656f1f7e70dea6cafc155e08268d5f0b57ffcb34f92bcd53eb87"
    sha256 cellar: :any,                 arm64_ventura:  "dccc667b31642b280a1ae140c1626efc9a407476f9223008520a78282842478b"
    sha256 cellar: :any,                 arm64_monterey: "c90a3715e044536c4650463c4a1def1c66b3cd31231cae668d3bfa2e6c616218"
    sha256 cellar: :any,                 arm64_big_sur:  "ade5ce2ed49545cd401c2f96ef600f36efa1a41701ecd4c3783bed067a66846b"
    sha256 cellar: :any,                 sonoma:         "3bb3a24d85787cf6a2ee0f55adc655c1b218074ef9b3268a11b6e9de77ad11d9"
    sha256 cellar: :any,                 ventura:        "91d4e7871b7e7f3cac1352590e5da0f6a0ba2e29194d4f5c37c9f4743c2107ca"
    sha256 cellar: :any,                 monterey:       "dfdf9c205d14096770df1c4e7ce0b45e857f379c3ce3d23b14f8f7e09c93afad"
    sha256 cellar: :any,                 big_sur:        "345ad0738741a9d382abd1ac18116128c68f4774785cda97966f9c89fca86693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222d7b3ada83cc778fb993e4706db5e6b03891379ad8c0f8272f6cb5693c01c0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "protobuf-c"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=TRUE"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    inreplace lib/"pkgconfig/libomemo-c.pc", prefix.to_s, opt_prefix.to_s
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
    pkg_config = shell_output("pkg-config --cflags --libs libomemo-c").chomp.split
    system ENV.cc, "test.c", *pkg_config, "-o", "test"
    system "./test"
  end
end
