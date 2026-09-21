class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "18ec63e28a42073db62e8fb59134b8bd410c29e8eb1d8ec1759efc9501fbf41a"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b69f3195192ae4d3d10c1439e2ef019f8c1c841a34be2ea99e52472bf3cf8662"
    sha256 cellar: :any, arm64_tahoe:       "08ea30c5f32a73bdbcaee060a806769b9176ca0ffffd5716e50b63574df48e86"
    sha256 cellar: :any, arm64_sequoia:     "526d573447d7f3ec3e5e7f9a513142926eef6011c8ea024f5c574291ffa8834d"
    sha256               arm64_linux:       "2e73955e2dd0078e77f0950688b347d99fbaab4c4708ca8145154cc0c99a131f"
    sha256               x86_64_linux:      "045208dee4bcdcb7ab74e45e521e090f60ac37097253efa671dbb3a7d55ccf59"
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
