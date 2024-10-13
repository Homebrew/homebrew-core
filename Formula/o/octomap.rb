class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "8da2576ec6a0993e8900db7f91083be8682d8397a7be0752c85d1b7dd1b8e992"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "429f4b461e548ab14d2eecd4c1599bceb2791956ef53e98c0f7814b242d799d0"
    sha256 cellar: :any,                 arm64_sonoma:   "808dfdfdf000b3da4f5223c77d5520bdb5078cc867bd98c2c27f9c1351c30e2f"
    sha256 cellar: :any,                 arm64_ventura:  "908e29c2a7423b82e4ce8cbe612595f1ab57a3e0e481d70caca34c0cbd77951a"
    sha256 cellar: :any,                 arm64_monterey: "420b3e35f3bd06f4eb1b33af0f3c85ef21666b1c1ba8946b8c6b89508133bb1e"
    sha256 cellar: :any,                 sonoma:         "7d6b02432d6144a747ca089b0b5bf3c873162373b4239b550bdfaf64968f027d"
    sha256 cellar: :any,                 ventura:        "c23f61388fadeb444fa809c33f35f24546ccaede8b5f30d52f1e676d0a65341d"
    sha256 cellar: :any,                 monterey:       "65c3b7a193ce7eec45b4aa579776df10a6fe6981d542a013d177d75d51cd7f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9e829f1df5f7f11c58e4477884ac1ba082590820b0cd00e361ba02effc6b50"
  end

  depends_on "cmake" => :build

  def install
    cd "octomap" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <octomap/octomap.h>
      int main() {
        octomap::OcTree tree(0.05);
        assert(tree.size() == 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}",
                    "-loctomath", "-loctomap", "-o", "test"
    system "./test"
  end
end
