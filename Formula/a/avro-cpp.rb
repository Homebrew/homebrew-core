class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.3/cpp/avro-cpp-1.11.3.tar.gz"
  sha256 "fba242aef77ec819d07561fcba93751721956de8d0cae8e1f2f300b54b331bae"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82b1a0dea57a3a31212c4276544e531efba46f7d19b45a9fc0b99a0b4a68c9d0"
    sha256 cellar: :any,                 arm64_sonoma:  "ea66a997dbb67c668b2efeefc6c55d99bb18eba228107a80ca62eab4c0e6d616"
    sha256 cellar: :any,                 arm64_ventura: "cb8df69dec1f3fd1fc81b92439e5f790f5d0b9b15c813c09fd67d2bce97faea8"
    sha256 cellar: :any,                 sonoma:        "1e6a8d749991317610e3b6ea1138a8e4d76d900a3aa705b5367cae864b2ee5b4"
    sha256 cellar: :any,                 ventura:       "bff702fbaa5e5d3804c890b944ae5f89466adab8cc589b6d69242f128bd9680f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9031c2d1bff4c0f2ceb59ae01efd28e0a983fd7d49eb8ab7a0e0dfbb4f8e1293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b869f1c4d9cb66d3cc15dbdb24ca17ad431d457807bfc7dab3aca7fe3015831"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"

  # Backport cmake_minimum_required update
  patch :p3 do
    url "https://github.com/apache/avro/commit/3aec6f413e3c47536b33631af5c18e685df0b608.patch?full_index=1"
    sha256 "c3f7ec1915e63c0ad08f277cf3392217e31eb11b6b2822f3a21d241901f461c7"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"cpx.json").write <<~JSON
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    JSON

    (testpath/"test.cpp").write <<~CPP
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    CPP

    system bin/"avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test"
    system "./test"
  end
end
