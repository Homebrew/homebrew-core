class F4ncgb < Formula
  desc "Library for computing noncommutative Gröbner bases in free algebras"
  homepage "https://gitlab.sai.jku.at/f4ncgb/f4ncgb/"
  url "https://gitlab.sai.jku.at/f4ncgb/f4ncgb/-/archive/v1.1.2/f4ncgb-v1.1.2.tar.gz?ref_type=tags"
  sha256 "0fd6bffa72e851953b12aae70d89fd17d45cf8db0eca636114b74c4ec0b7449b"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "flint"
  depends_on "gmp"
  depends_on "mimalloc"

  def install
    args = %w[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CXX_STANDARD=20
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DENABLE_NATIVE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build-release", *args, *std_cmake_args
    system "make", "--directory", "build-release", "-j"
    bin.install "./build-release/f4ncgb"
    libexec.install "build-release/f4ncgb_test"
    pkgshare.install "test_inputs"
    pkgshare.install "parse_tests"
  end
  test do
    cp_r "#{pkgshare}/test_inputs", (testpath/"test_inputs")
    cp_r "#{pkgshare}/parse_tests", (testpath/"parse_tests")
    output = shell_output("#{libexec}/f4ncgb_test 2>&1 1>/dev/null")
    assert_match "No errors detected", output
  end
end
