class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ac7aadc57d218a5186076f55255202ec7d0949c7f334b8b0cec8bdd196cd75d7"
  license "LGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ed742c9bb5905f55e116bf5b81074a8b33980f067b5126e402714500fc06d4c"
    sha256 cellar: :any, arm64_sequoia: "5e6c85852ab5bc97563b4bd8001e10440170c32107e2c427f2cfb23d06c62971"
    sha256 cellar: :any, arm64_sonoma:  "b23f83ba1a62f1be6576d49215394dc4988bc9bbeb8fff3232233dd971aa567f"
    sha256 cellar: :any, sonoma:        "15046ffa111a17b122495311b44662cd41ebb18b1e04f83807e11ed6435f2230"
    sha256               arm64_linux:   "d8f772228565fc9b79fa9f5d7b85d9a2824170209ebb5cb773931367208ec9f2"
    sha256               x86_64_linux:  "9995bf500802fd752a11879e80f2e1eea7280511f7ff52f3c7f101ca1cefb1c9"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <osmpbf/osmpbf.h>

      int main() {
        OSMPBF::BlobHeader header;
        header.set_type("OSMHeader");
        std::cout << header.type() << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, testpath/"test.cpp",
           "-std=c++17",
           "-I#{include}",
           "-I#{formula_opt_include("protobuf")}",
           "-I#{formula_opt_include("abseil")}",
           "-L#{lib}",
           "-L#{formula_opt_lib("protobuf")}",
           "-L#{formula_opt_lib("abseil")}",
           "-losmpbf",
           "-lprotobuf",
           "-labsl_log_internal_check_op",
           "-labsl_log_internal_message",
           "-o", testpath/"test"

    assert_equal "OSMHeader", shell_output(testpath/"test").chomp
  end
end
