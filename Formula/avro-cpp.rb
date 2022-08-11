class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.1/cpp/avro-cpp-1.11.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.1/cpp/avro-cpp-1.11.1.tar.gz"
  sha256 "2eec5e5a708350b50fdec9636b968a3e318170313ef2d45ec90992108757198c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d145604463d480ee07b3794aff978506e8b6b9416e6026fcfd535b8ed4e6d04e"
    sha256 cellar: :any,                 arm64_big_sur:  "e3593bbb6bee2823fb7579f905811185a8ba2e8210adcd4638c35a658e625aca"
    sha256 cellar: :any,                 monterey:       "4e7669cb5ad4b716ea291d0d6ae21a81f9f1788c214fbf3d4c29b00f4ee0d39a"
    sha256 cellar: :any,                 big_sur:        "a402156606df45a62409bd79abf55fb5758e17458a02085aafc8ae2d9717a126"
    sha256 cellar: :any,                 catalina:       "d99a75d903f5f4e39b13b553d087f0ac6c538dc367f3c89c36baca6945714ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d487876c7a03a2c2fce379cb73105b33b19adbfcd1ea38f67dd9da76e1442506"
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
