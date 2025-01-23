class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.18.tar.gz"
  sha256 "e5003fa324362255d837899186cd0c3e42d376664f0d555e7e7a1d51334817c9"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9d7337dedb52872bd7519b923fca4d0f42fa07d3a39b99855715401555dae56"
    sha256 cellar: :any,                 arm64_sonoma:  "ec1ecec6d98c010eeeb0972b027c275188e82cb10cbd39048cdb4252be7b1575"
    sha256 cellar: :any,                 arm64_ventura: "e0525044a406b7a0e53ce2aa395fa7ecf21dfc2b28ea7b4c7ce162291da087b6"
    sha256 cellar: :any,                 sonoma:        "320d2635c2ec32ccd3de2127a8736e7e0e34278bb08863656dea52027f0904af"
    sha256 cellar: :any,                 ventura:       "c1173ffd2a8bec573cc70073fe764fc0fbeed8c9659a31eb3f12917f80a7a03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8aefc291785e6952f1b6e2f0d51e90266934d00e8abfb66c5328a7820c1bf2b"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "needs OpenMP support"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end
