class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "a47cfa36e255e4bf16c63015aaff8e6fe2afc14ffaa3f6b281718158446c0e9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d405725fb107bc5802db04305b5981021d43d85549816bba0e0f05aabd22cca"
    sha256 cellar: :any,                 arm64_sonoma:  "20a351fb6bf722a782fc54016671dacb183ac4b1b13f2839b50d950d50cce4ad"
    sha256 cellar: :any,                 arm64_ventura: "47213e30f88fc3293049ae8827285188284173fb7bd56ee5dcfd9e01b523d966"
    sha256 cellar: :any,                 sonoma:        "efb8ab1396d50289cff7f284834da7949b60e7d8fdda67372579150e155a2a94"
    sha256 cellar: :any,                 ventura:       "238925854566dc1f663188441e70161e776ecb8ee5e83e302fd02cca982bdea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c17d9170276ef83b6338b519f6438339f46685ed9b89814c64f15d235e5965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e555c5f66845f353c2592dc83923631952464cb59aac583c577dde1be0dadc03"
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
