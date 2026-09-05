class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ac7aadc57d218a5186076f55255202ec7d0949c7f334b8b0cec8bdd196cd75d7"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a71dcf427e13a3220552238ec611c99d34e3b67166d621c26cdce33ad5c2cbfb"
    sha256 cellar: :any, arm64_sequoia: "567b6845dafd661a4f0d3e14d014d74f574445b72801a917244c239074802524"
    sha256 cellar: :any, arm64_sonoma:  "b6faf6090db9662b681ae5ab9da17c7faab3f097847b39e393f59c87aad99d24"
    sha256               arm64_linux:   "f5220183b683fe9a38774f5ba57a2cf56373a4c5d020466e3b9475599b187465"
    sha256               x86_64_linux:  "7d1028b768d9c222430c86cc9709e9c008d13d795a253ec99600a4ec57aeaf08"
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
