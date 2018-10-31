class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org"

  version = "2.2.0"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-#{version}/apache-pulsar-#{version}-src.tar.gz"
  sha256 "a3b1940a803043bb2c365ce9df657d15bf9aacb3c9ff5db86a79dc4374033f08"
  head "https://github.com/apache/pulsar.git"

  option "with-python3", "Use Boost with Python-3.x"

  depends_on "cmake" => :build

  depends_on "boost" => :build
  depends_on "jsoncpp" => :build
  depends_on "openssl" => :build
  depends_on "protobuf@2.6" => :build
  depends_on "pkg-config" => :build

  if build.with? "python3"
    depends_on "boost-python3" => :build
  else
    depends_on "python@2" => :build
    depends_on "boost-python" => :build
  end

  def install
    Dir.chdir('pulsar-client-cpp')

    system "cmake", ".", "-DBUILD_TESTS=OFF", "-DLINK_STATIC=ON",
      "-DPYTHON_INCLUDE_DIR=#{Formula["python"].include}",
      "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}"
    system "make", "pulsarShared", "pulsarStatic"

    include.install "include/pulsar"
    lib.install "lib/libpulsar.#{version}.dylib"
    lib.install "lib/libpulsar.dylib"
    lib.install "lib/libpulsar.a"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv)
      {
          pulsar::Client client("pulsar://localhost:6650");
          return 0;
      }
    EOS
    system ENV.cxx, "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
