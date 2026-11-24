class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "18ec63e28a42073db62e8fb59134b8bd410c29e8eb1d8ec1759efc9501fbf41a"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    manifest_sha256 "7f144659d4f0f4e8c872ede1b9e70ce3536470ac201d45f3fe9dd392f7e303d8"
    sha256 cellar: :any, arm64_golden_gate: "83801c79fd2a703f6b1738687672f5f47b5695bf96e5a113ee32168d814ce00d"
    sha256 cellar: :any, arm64_tahoe:       "e15aba68e664e6d37121a7d27f7051a50271df19f5acd8220ccedc7ddccfbf64"
    sha256 cellar: :any, arm64_sequoia:     "5a33fb82dfbbb6684ae0732acf009343c00ded6e76d64383177eae0b25f621b3"
    sha256               arm64_linux:       "ffc41c1c148d29cdd3dd3e8987cc7f75334c3e0c9f6d457f6df4866d249cadaf"
    sha256               x86_64_linux:      "905786d7c4840a18cb2993f32bce2d9741e8df42bb4b2be37453d56f92b89ea6"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  deny_network_access!

  def install
    args = ["-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs"] if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
