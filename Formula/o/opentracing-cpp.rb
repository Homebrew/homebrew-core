class OpentracingCpp < Formula
  desc "OpenTracing API for C++"
  homepage "https://opentracing.io/"
  url "https://github.com/opentracing/opentracing-cpp/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "5b170042da4d1c4c231df6594da120875429d5231e9baa5179822ee8d1054ac3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e30de6dd8cd5968ca9e06daa0f2e6bc3f750f55adf8a7b70c981e79df7704932"
    sha256 cellar: :any,                 arm64_sonoma:   "7da4222d346f9ea96d1fbf8d89662250c82876a1f5cccbf2a335af1e6cf9ae71"
    sha256 cellar: :any,                 arm64_ventura:  "ccbb5e255e5f6708324c7d8853e5d9e16e6409d061d465628fa876f0371454bc"
    sha256 cellar: :any,                 arm64_monterey: "50677ac8a2082e88324b45764c2f2d46dd70df23261c13e4e4fdfe4577505635"
    sha256 cellar: :any,                 arm64_big_sur:  "47fd29e6c0a73f405ac424f95299aa1d68a2735061cb6b96b262eea6a935210e"
    sha256 cellar: :any,                 sonoma:         "4ed62529cded82524f26b3e690ffa4ba74811cfa320f8d35d8f82b002f987890"
    sha256 cellar: :any,                 ventura:        "41295146fee1dafe218d97dd70061260ffa49bdee9ddc7c23bd465f97a4abb74"
    sha256 cellar: :any,                 monterey:       "a84c5a3c3fe04de1cc52d24381af68f5d054a353bee01fb10fb1abe6c4cbd0c9"
    sha256 cellar: :any,                 big_sur:        "1a904785b31fe03fc39333e81dc06e815b649c92062e23a99cf24137a013227b"
    sha256 cellar: :any,                 catalina:       "151a5af54448492f668979eb3a0e9fb92e2e1a99cb6766ba3985a9a88f26526a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f61d48bdd3ed6cc866a9a1da22fa9ca861a67b3aa253e7bd38416eec8b9f42"
  end

  deprecate! date: "2024-03-09", because: :repo_archived
  disable! date: "2025-03-24", because: :repo_archived, replacement_formula: "opentelemetry-cpp"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example/tutorial/tutorial-example.cpp"
    pkgshare.install "example/tutorial/text_map_carrier.h"
  end

  test do
    system ENV.cxx, "#{pkgshare}/tutorial-example.cpp", "-std=c++11", "-L#{lib}", "-I#{include}",
                    "-lopentracing", "-lopentracing_mocktracer", "-o", "tutorial-example"
    system "./tutorial-example"
  end
end
