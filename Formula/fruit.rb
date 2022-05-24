class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.6.0.tar.gz"
  sha256 "b35b9380f3affe0b3326f387505fa80f3584b0d0a270362df1f4ca9c39094eb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c42c1879ad107e5ee827ad6bcd18097575bf8818c3d7b6147a5aa33d166bec0a"
    sha256 cellar: :any,                 arm64_big_sur:  "1efe400614d7043d482a1983f780a4d4792112e039a5939e0fb0e5cdc64d2ad6"
    sha256 cellar: :any,                 monterey:       "ac4e32b4cce26112871dcc8d01fd93a5ccbeac0dbae23a6d4bced050cea99eeb"
    sha256 cellar: :any,                 big_sur:        "a08a4deb118150ef8237de0dfe4ac6215a729b504f25881950e0113016a9011b"
    sha256 cellar: :any,                 catalina:       "10f1081e14b11a547b36020cdfa75486fac42036389b37d2df831f586fc78429"
    sha256 cellar: :any,                 mojave:         "fc0a6e56340a21a4548f589d38df7b52bd6edabb483e6c6e0a9fe8605a373a8f"
    sha256 cellar: :any,                 high_sierra:    "73e0c030fb7984d5b3b72d11410ca2f30c4e5a66ba183070fc3ae8a919ea5094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a526dc1dff57ea51ec8256439697d5f061c3b99085e4b41281de2512ba45716"
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
