class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "b3bbadf9ee9f05792d08f626dd0e784489fdad662eb2fbf311683241706bf60f"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    manifest_sha256 "685ea36debab328864334caf2b032ca119c3ad461897451cea727befabb67349"
    sha256 cellar: :any, arm64_golden_gate: "ff93f09cbd57bb6d6117f039c8f1ca0cd3276cdd41e466d5e5d51c95a986bc77"
    sha256 cellar: :any, arm64_tahoe:       "2c814f701f0627a1f583f246795d37b860b568f1fbe77a16177cf815ffc1adc1"
    sha256 cellar: :any, arm64_sequoia:     "eee58994823474b95b50bf772a94ef9a2059a4edaf4361f9096eaafa292f9ceb"
    sha256 cellar: :any, arm64_linux:       "6ac30323959943b4563822b995782571639c6f65a83c96c95f61a86f13273a5a"
    sha256 cellar: :any, x86_64_linux:      "df56717a1cf4202be47303582b6a9d258562fbc905d1a7d68b03cb38c6a6dc06"
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
