class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ac7aadc57d218a5186076f55255202ec7d0949c7f334b8b0cec8bdd196cd75d7"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "665ae8d9caacabc8885555ebc779de368811f5776ffe1612396a2de55bada331"
    sha256 cellar: :any, arm64_sequoia: "6a69e0affed26f9bfe58c67088590cde5be31712c0fbfc791a577e64b1e71ba5"
    sha256 cellar: :any, arm64_sonoma:  "b3f03a3d7158ccad41b3ca90d0f4f5b916a1a9b7f86aca0cc5f15e94f609fe80"
    sha256 cellar: :any, sonoma:        "7c885d1b6349f67b41aaf1a3e5a7297d1905cd66a304bfae2cb7013bb5036526"
    sha256               arm64_linux:   "886bb0e090a7a67c1e8b321a03a2229e47ce4352823099741b04387860d74391"
    sha256               x86_64_linux:  "a4c2b8d171afb539f17248ac3223d5cd17419681ce8694d4f3e708dc410c0366"
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
