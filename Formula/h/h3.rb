class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "0da8a392a6ff77e76b60e6a331a49497d0935b6b7b6899da7a3e2786139b0441"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e3f39b1aecc3663c9a4fdea3146394ead92fa683b017f10489ac57649b94018"
    sha256 cellar: :any,                 arm64_sequoia: "39da112d907ede88f72c3cf73541d6f68daffb58f8eb6982c434c309d5cf98a0"
    sha256 cellar: :any,                 arm64_sonoma:  "0a6359a8c8a7b4061021f515759e4b2ceaf1f460ba8feff0c1870d3b82a3b180"
    sha256 cellar: :any,                 sonoma:        "a9e5bedf882869d4ae52ed80288017dcdccca564a89e1b9aed074f4e5c761a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab65a258143f569d9ae7f4d0d339450778b012d5c36e4d308f12cb64a90654c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5938a424227114affaf192366ce61c0cde72dcd3796fad1df0a3693b1656c9"
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
