class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v13.0.2.tar.gz"
  sha256 "eee68f88cce153cde6aa1d73c844677681dfc6c57ae7f4cb6a0354da0f3b3b80"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d5a97b2b3c391bf63ff746c1403b80bc82c44eaa5d5ca38d232254402d1154ab"
    sha256 cellar: :any, arm64_big_sur:  "1f699bf2cf781876c7000035594cf2f0a983e07558806b9816ab350830fc6a66"
    sha256 cellar: :any, monterey:       "01d6a51835dd75a60dd150192edad9f294008967eebef0b4a6813395396b6a1f"
    sha256 cellar: :any, big_sur:        "5cf6fe459107a26ecaf7a5cbd07dc5a612f5dd46d90c17673498fa8055265b6e"
    sha256 cellar: :any, catalina:       "cd84e6b14d31425abac2b9c5843a0fc4820c66fb7fc1ea582c83736a555c8d57"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.10"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHalide_SHARED_LLVM=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
