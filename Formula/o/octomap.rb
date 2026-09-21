class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "b6b6c10c99ab15701dd105840e7d4cf18e226eb68714dd4bdfe049dede5cd489"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ebe6fd230093c36f670de6dde66f7f135a064f4953892a0cfe655e2280455c91"
    sha256 cellar: :any, arm64_tahoe:       "341f9ad94e1234a57a01680062414ca5f729a3c3f497e2b1cec9f1a07566b1b4"
    sha256 cellar: :any, arm64_sequoia:     "ee0e6c608e4dbfa6f0fa0388bbe0710cf602121d25d877c1ed86043752a901a1"
    sha256 cellar: :any, arm64_linux:       "2faca0e4b7d529f5a098e081b167f994f58601dc759d40e61f416168ebf0c5ff"
    sha256 cellar: :any, x86_64_linux:      "61d4e164f82d93c8c7fb050ccdfddcc965ce7bd1346687e6b73fa52efa512972"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  def install
    system "cmake", "-S", "octomap", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <octomap/octomap.h>
      int main() {
        octomap::OcTree tree(0.05);
        assert(tree.size() == 0);
        return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs octomap").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
