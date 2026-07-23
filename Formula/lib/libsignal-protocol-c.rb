class LibsignalProtocolC < Formula
  desc "Signal Protocol C Library"
  homepage "https://github.com/signalapp/libsignal-protocol-c"
  url "https://github.com/signalapp/libsignal-protocol-c/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "c22e7690546e24d46210ca92dd808f17c3102e1344cd2f9a370136a96d22319d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9a8ecae4c6099cd0732fddcd94730e7e8dc361e9f625fab00279792700e64130"
    sha256 cellar: :any,                 arm64_sonoma:   "5ea0c5c2b3ae7de38ab640492eb6e0627d1bd329413a18520c93c0699309f29d"
    sha256 cellar: :any,                 arm64_ventura:  "c2e2d424032060b1ea5eaad3e977c6bc2d2704c8aa1a43c371e119c06d68f1f1"
    sha256 cellar: :any,                 arm64_monterey: "28c12c6c31a0950b035347de5e67aca8a0057793bf35feb2b4dbe1d342a2682d"
    sha256 cellar: :any,                 arm64_big_sur:  "ae7936606ffb1bcc2cce9e6854bc6fa7cd6fcf44ae67b17b7a861158fa58ca7f"
    sha256 cellar: :any,                 sonoma:         "d9edd40514a689492c36549a43d74312e81c3e0a764bcc22e645e5af82059c67"
    sha256 cellar: :any,                 ventura:        "b5cf27a68fe60b12da74c76b2bbe0485a82c5662f7c6c3becde96053d364febc"
    sha256 cellar: :any,                 monterey:       "a5216e8239283c702a4c68d4f63da4cfa9e532d4452d0edc8ed560c7aa38900d"
    sha256 cellar: :any,                 big_sur:        "16cbd5edd6e2d6a2905a6cf1d4b342deb3b356093c1945a9a4333038fbb3b60e"
    sha256 cellar: :any,                 catalina:       "2ad98569b7c0543579c9a2596a78e86bb7a915fb17632850cea099feb9d2d674"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "313d261c9a30af89903531ff44ac68c58955e112edafe4afdf68225824ccebd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d3f06b8dc3938b4dc6912a65606713000e6ad910c4bfcb4af4e9c0dca899e0c"
  end

  deprecate! date: "2024-08-01", because: :repo_archived
  disable! date: "2025-08-03", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system ENV.cc, "test.c", "-I#{include}/signal",
                   "-L#{lib}", "-lsignal-protocol-c",
                   "-o", "test"
    system "./test"
  end
end
