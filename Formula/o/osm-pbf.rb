class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "18ec63e28a42073db62e8fb59134b8bd410c29e8eb1d8ec1759efc9501fbf41a"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "23b5ac3a921c0948150d216311e33bdafb56fe8b3da5574917ff6b64eb42abd7"
    sha256 cellar: :any, arm64_tahoe:       "62cde7596eeac37a139a871714c0fb91737dc8ab7683abf540598195e6686b00"
    sha256 cellar: :any, arm64_sequoia:     "70648542a758c55f3aa6bcd75b49befe0336ec27a3168dac311f50499d562651"
    sha256               arm64_linux:       "36e081e07f77d9a73384c63156174f516b4be97962eaf99491a5024fa1d1f973"
    sha256               x86_64_linux:      "dd463a2108cf7bb1141732e85a29751581b8badd2d782c538d9f1bec1f20dd30"
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
