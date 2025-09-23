class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  sha256 "e4eee34cfa3d5838c08f20ac70f5b28239cb137bb59c75199f809141070620dd"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "deebf95d6fee145d6b97d50fcc5af6535d2f5aea940114c3e23756979508ee4c"
    sha256 cellar: :any,                 arm64_sequoia: "16cc8c89de5c1e2b60bfbd12605a32499ef7f9297c6b77b78e55eee87292b84d"
    sha256 cellar: :any,                 arm64_sonoma:  "2d86c8b079260d14c0b4613dbffaf6aeecf5910320b3c99d224b264f26f39e23"
    sha256 cellar: :any,                 sonoma:        "78caacf3c5c2e4d4fd3e81a4846668fcbbdb0f30f0ff8f69123f778f8fd4bd7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4498724ed77815c01cef875e50b239ded2433d0a4cad976b51bff16c99dd3d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36b1ec1ea60902233499659b654de11924907eda520a8e16b4e522e3e60e5b95"
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

  # Backport of https://github.com/apache/pulsar-client-cpp/pull/477
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/93a4bb54004417c3742ca0e41183c662d9f417f5/libpulsar/asio.patch"
    sha256 "519ecb20d3721575a916f45e7e0d382ae61de38ceaee23b53b97c7b4fcdbc019"
  end

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
-    const std::string rootMessageTypeName = descriptor->full_name();
-    const std::string rootFileDescriptorName = fileDescriptor->name();
+    const std::string rootMessageTypeName = std::string(descriptor->full_name());
+    const std::string rootFileDescriptorName = std::string(fileDescriptor->name());
 
     FileDescriptorSet fileDescriptorSet;
     internalCollectFileDescriptors(fileDescriptor, fileDescriptorSet);
