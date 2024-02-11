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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d628c38ed7a4b7a5e05f685cc69093051bc499ea54b0ce974e0bd022e06a3e41"
    sha256 cellar: :any,                 arm64_ventura:  "9153c79689fafe4bf276c519934345494b4407da58d90bd59108586837731ce6"
    sha256 cellar: :any,                 arm64_monterey: "15b0bd6a7ddbdf62f50ca3932a9d0dc7f2541ce18583c367be9982808d8f0769"
    sha256 cellar: :any,                 sonoma:         "6dc5dba963a9f0c267b39c95de80f654e5367262ff4627dddea36e08f3bbf8c3"
    sha256 cellar: :any,                 ventura:        "acd92e352dadd4aa00687ec705712b5c7c28e36dfd0a50461a1c0c071ea64418"
    sha256 cellar: :any,                 monterey:       "fd8ad4f25cd52444d42b688c8dfea3b595d249d8f61ba40f107ff4d1be19dd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5918b80c38cf4f78d34ae3e93fa0cf5fdceff4621ab40188fad1c2ec2f1fe254"
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
    args = %W[
      -DBUILD_PROGRAMS=ON
      -DENABLE_PACKAGE_CONFIG=ON
      -DINSTALL_PKGCONFIG_MODULE=ON
      -DBUILD_EXAMPLES=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "static"
    lib.install "static/libsndfile.a"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
