class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/v2.4.1.tar.gz"
  sha256 "d6b4650ff897ee1ead27cf77a5933ea197cbeef6705638dd181adc2e816b23c2"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2971d7cf8b4c8783fc26b4df34b62c18154ee2ab30a23fa60b2161b6f86952d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32f5c7935fad82f881fb7871a1e3460918ff77d7af747f4a2fce8c3f0e3e3e4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6474e67e155044f94bd27f589a4ce3789723b87916c05a83fea19b9f5afc7a41"
    sha256 cellar: :any_skip_relocation, ventura:        "85eabab92c7555fd7e1ad23e8fd78b7b01ba3bf5819f8dc743bf6a9ccbffeedd"
    sha256 cellar: :any_skip_relocation, monterey:       "501b55a5647ee9ce43457ca9df4661069fb915de9f146a77bbac0b856d56f417"
    sha256 cellar: :any_skip_relocation, big_sur:        "752a3bae8af1fbcd90d9d27a42ba5a5f32006ae6673bbeeb0479de7bf53d833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae074d4d7908a32096b8dc093636e0323e9bd94f36d9ee7290a60dd5199fa234"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :test

  def install
    args = %w[
      -DBOX2D_BUILD_UNIT_TESTS=OFF
      -DBOX2D_BUILD_TESTBED=OFF
      -DBOX2D_BUILD_EXAMPLES=OFF
    ]

    system "cmake", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
    pkgshare.install "unit-test/hello_world.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"hello_world.cpp",
                    "-I#{Formula["doctest"].opt_include}/doctest",
                    "-L#{lib}", "-lbox2d",
                    "-std=c++11", "-o", testpath/"test"
    assert_match "[doctest] Status: SUCCESS!", shell_output("./test")
  end
end
