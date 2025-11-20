class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.8.0/apache-pulsar-client-cpp-3.8.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.8.0/apache-pulsar-client-cpp-3.8.0.tar.gz"
  sha256 "e5abff91da01cbc19eb8c08002f1ba765f99ce5b7abe1b1689b320658603b70b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06faec1986e38c99e55caf96a1d55202b63a42a596021bff5b5cd2dbf95548d2"
    sha256 cellar: :any,                 arm64_sequoia: "09874631db6c53c05ba9ea496fbe5ed04a44ff1ec42a5d2e9ce0bbe8d1dd6309"
    sha256 cellar: :any,                 arm64_sonoma:  "b82bec4a04d2ca3229070c7a8add8ac14600a564fbcf33e402ff98ce41fc2990"
    sha256 cellar: :any,                 sonoma:        "38452d447b930a8667e046f7b189f929443f24202d115eab651af1c29b422df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22930f51a83832d9c16986394e720b31a8fbe4fbc884e90656f1e268782f7074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1f14b5ac5e5faaf3461162da1bd2df43dcd7c80fdf3d5e48b964f880533425"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Workaround for Protobuf 30+, issue ref: https://github.com/apache/pulsar-client-cpp/issues/478
  patch :DATA

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]
    # Avoid over-linkage to `abseil`.
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/lib/ProtobufNativeSchema.cc b/lib/ProtobufNativeSchema.cc
index 5cddf74..4bf45cf 100644
--- a/lib/ProtobufNativeSchema.cc
+++ b/lib/ProtobufNativeSchema.cc
@@ -39,8 +39,8 @@ SchemaInfo createProtobufNativeSchema(const google::protobuf::Descriptor* descri
     }

     const auto fileDescriptor = descriptor->file();
-    const std::string& rootMessageTypeName = descriptor->full_name();
-    const std::string& rootFileDescriptorName = fileDescriptor->name();
+    const std::string rootMessageTypeName = std::string(descriptor->full_name());
+    const std::string rootFileDescriptorName = std::string(fileDescriptor->name());

     FileDescriptorSet fileDescriptorSet;
     internalCollectFileDescriptors(fileDescriptor, fileDescriptorSet);
