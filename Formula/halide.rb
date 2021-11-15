class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v13.0.0.tar.gz"
  sha256 "5ab7d5d9bc04ab0902a88751e535ff231ab9da1911e46f272a52cf41131609f3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "7119b59b17096b5058351130db13779ea3391ac070beb6408ccf959acb3983a5"
    sha256 cellar: :any, arm64_big_sur:  "e3b06807e1cfc4011588b03d4b0360163fab45eb5b734ab53c1fe1e7c2a03870"
    sha256 cellar: :any, monterey:       "f64c5c1fe3e0f08171291510345eb6fa296dee0e03a6b5ba355acad93850517b"
    sha256 cellar: :any, big_sur:        "95a2702948a1dfc83296a09ae4d3c4a7e38786229070a6cf46a36124dcd3325c"
    sha256 cellar: :any, catalina:       "55b2fb8fe06c09e9dfb03cf1f52cf3e8a002139fb467c457d4ae7b0cfe4cb0ab"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.9"

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
