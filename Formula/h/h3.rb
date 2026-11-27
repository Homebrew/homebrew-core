class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "071be536307b9d6c84e3c024ed9aa4b35f8af5a1eff7f1238c04831fa4a77e68"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "d40848f2c87c1afc85da6e8836db191728f5e656f9aeb2adbca1bee747aa9b81"
    sha256 cellar: :any, arm64_golden_gate: "88374021e91f01aaaeef212a80075469e1f46427850aec9c651e52031900213f"
    sha256 cellar: :any, arm64_tahoe:       "86f52938236e1da805e4e320640424344cc5af442a8e03e9619f67ad17db0b46"
    sha256 cellar: :any, arm64_sequoia:     "0e5233913a9b529316cf04bc3c212f5d477e0bec6de6522dd002e974ac47e380"
    sha256 cellar: :any, arm64_linux:       "3fb578b16d9cf684415c22423e3f8babbbd2a7ee436b8a2e8a6a36bddc6927b9"
    sha256 cellar: :any, x86_64_linux:      "5f12a97189905085fdbd136d3894af8e95c5f068ea42e84bd74eeaea3943fd2a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    result = pipe_output("#{bin}/latLngToCell -r 10 --lat 40.689167 --lng -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
