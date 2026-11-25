class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "a47231ec8b7cca3147e611caf31a100dfc24a2257dcc58cff1a047519586befa"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    manifest_sha256 "df858b90cdadbd0299204446bfd93b7c2794b5b2dd8a86049733f6d97bed1d5a"
    sha256 cellar: :any, arm64_golden_gate: "267f21316912ef32434722e059c2e5e3a96c9220fa7595591539b3fcc02548a7"
    sha256 cellar: :any, arm64_tahoe:       "491b5e4b8a83439616507ee532c609cb7bf1eb3109838959d4ad7857eb7646b3"
    sha256 cellar: :any, arm64_sequoia:     "31266b172e6598747b42f594430e0b534c01897feab7143b8529f31d82d5884f"
    sha256 cellar: :any, arm64_linux:       "639e63f27fc3e64740d45a2c82e70681000e2d3d249fc1f861d1274ab6cd8ab1"
    sha256 cellar: :any, x86_64_linux:      "1da29ede1e46d8a335599c647f43bd9db4def224372c41494e3cb399eb584274"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", "octomap", "-B", "build", *args, *std_cmake_args
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
