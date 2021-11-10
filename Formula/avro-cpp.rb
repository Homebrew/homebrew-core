class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  sha256 "ef70ca8a1cfeed7017dcb2c0ed591374deab161b86be6ca4b312bc24cada9c56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "52aa8334c8c849b4d260c4dbe56d25073f759093a98b470d86e2b16180b8d832"
    sha256 cellar: :any,                 arm64_big_sur:  "45f7b85124ea8c41ce28430e0a45191aae04991458548f7938b80f4ffb050783"
    sha256 cellar: :any,                 monterey:       "bd9e8f962c8078fd513af74e8446707ea8d7c329bac37ec6b388c51780d748bd"
    sha256 cellar: :any,                 big_sur:        "c153805420d4e6c1ba2d7f3778d6bfc9a353bd54c4a4154700b70066d7196901"
    sha256 cellar: :any,                 catalina:       "52837c2b6a31fd403c29e53f701a051bdd42aac110ded8fec8dc69b36f7fe3dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3587194ff0ed059c7a60a218255248e61b689d59985874e8abf71c628cb620f9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}/avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
