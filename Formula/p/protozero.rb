class Protozero < Formula
  desc "Minimalist protocol buffer decoder and encoder in C++"
  homepage "https://github.com/mapbox/protozero"
  url "https://github.com/mapbox/protozero/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "6c7a896f1dc08435e8cd4f3780ff688cd0bfce6890599b755f6f3cb36398dc25"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e5449eeed0e64413afe0b49e9bbc162c0a5c9a1d2e91e992adf5c281413ad5a"
  end

  depends_on "cmake" => :build

  def install
    # We only install headers, so we can skip `cmake --build`.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
    pkgshare.install "tools"
  end

  test do
    system ENV.cxx, "-std=c++14", "-I#{include}", pkgshare/"tools/pbf-decoder.cpp", "-o", "pbf-decoder"
    assert_empty pipe_output("./pbf-decoder -", "")
  end
end
