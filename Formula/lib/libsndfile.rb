class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.2.2/libsndfile-1.2.2.tar.xz"
  sha256 "3799ca9924d3125038880367bf1468e53a1b7e3686a934f098b7e1d286cdb80e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0d50a581032c9791f8e36c41f7284a3883b42d7f6e23175392eab1d87989e99e"
    sha256 cellar: :any,                 arm64_monterey: "547fe6bd512625b461f9882cd5029f49bafe3de7acc998aa773ae62bd6050527"
    sha256 cellar: :any,                 arm64_big_sur:  "75a2ee999c1663e3ea707dc472c29cfeb752f257ae5e24125726876a1667e009"
    sha256 cellar: :any,                 ventura:        "9f646d3fd4351b4e7283cb53bdc96b74ff56e4d77aaa715f3cf1d61f3877652d"
    sha256 cellar: :any,                 monterey:       "b1515b56788d6e87b6f56cd592a52d12344de897eda10852cbb09765eb8d0374"
    sha256 cellar: :any,                 big_sur:        "ad1f35e4deb5c32a6ff6cb6c7a96978549d5e41f3c21fb510082120826714397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "914371e566d295641a09cc67688dace4ea21b7a2952c8a97e7ba8e29d00358d8"
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "opus"

  uses_from_macos "python" => :build, since: :catalina

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_PROGRAMS=ON",
                    "-DENABLE_PACKAGE_CONFIG=ON",
                    "-DINSTALL_PKGCONFIG_MODULE=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
