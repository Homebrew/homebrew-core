class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.8.2/libatomic_ops-7.8.2.tar.gz"
  sha256 "d305207fe207f2b3fb5cb4c019da12b44ce3fcbc593dfd5080d867b1a2419b51"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https://github.com/ivmai/libatomic_ops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "27c948cb8ca7db52ae09a76402fd1180ca110ece2ba7a20c88b16902967980f4"
    sha256 cellar: :any,                 arm64_sonoma:   "b1b86350238369d9aeec01fe06db92fa0bda5aadabdc6867e4d7f34eca09b72f"
    sha256 cellar: :any,                 arm64_ventura:  "df3aefc169055fa94ec868131c894b8fcae8dc7ea33e64a700e3746576e93ebb"
    sha256 cellar: :any,                 arm64_monterey: "81dde253b3f27f98a1b64110ec13ba9181e8ab34bc0060fc878e98e6090777ba"
    sha256 cellar: :any,                 sonoma:         "4f402b92483d9647fc328a8b02e2ea1abeb25d3460720f4530d3cc432c5c5550"
    sha256 cellar: :any,                 ventura:        "37d4fa5e739558798fc23471ba5efe49043ec46a8c07242fcc790f28f9940806"
    sha256 cellar: :any,                 monterey:       "e673e4f5126a4c2d43a98209bd9165413fc6d189d22e3481824bca60f74ec4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1eac8d8ea0bd234b72ce311c92d02dc2ca33029b819327b6c2236309d549bca"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-Dbuild_tests=ON",
                    *std_cmake_args,
                    "-DBUILD_TESTING=ON" # Pass this last to override `std_cmake_args`
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build",
                    "--parallel", ENV.make_jobs,
                    "--rerun-failed",
                    "--output-on-failure"
    system "cmake", "--install", "build"
  end
end
