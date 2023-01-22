class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.7.1.tar.gz"
  sha256 "ed4c6b7ebfbf75e14a74e21eb74ce2703b8485bfc9e660b1c36fb7fe363172d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0f1843d64e4df3748846f8c226e6b66824c0c62d732f705ff997ce16a5e37682"
    sha256 cellar: :any,                 arm64_monterey: "ddf2d6282b81ad922dd8321dba09ca1d25082f5fecc9fb0166165a95ebc3aab6"
    sha256 cellar: :any,                 arm64_big_sur:  "200d4781a590085a2b3e7ea8bda377bb7687edc069cff2b5b48146ed08e5b0c9"
    sha256 cellar: :any,                 ventura:        "98875f0ceb024eab77b7ec038cc5923eb147e927d559c51e631b3960775526cd"
    sha256 cellar: :any,                 monterey:       "2975ade3341b617ef973fef8584b996a4443bac3308fc7a46dc07f33ecb42072"
    sha256 cellar: :any,                 big_sur:        "cc9f88c9d379ba932c8379d97b6a2179941454075e3841551a17edebfdab3258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d643ef53a32e2dbe79403388da70c13c46c9da5f3a52152c6320f35a5b8ac23"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DFRUIT_USES_BOOST=False", *std_cmake_args
    system "make", "install"
    pkgshare.install "examples/hello_world/main.cpp"
  end

  test do
    cp_r pkgshare/"main.cpp", testpath
    system ENV.cxx, "main.cpp", "-I#{include}", "-L#{lib}",
           "-std=c++11", "-lfruit", "-o", "test"
    system "./test"
  end
end
