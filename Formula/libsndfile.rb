class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.2.0/libsndfile-1.2.0.tar.xz"
  sha256 "0e30e7072f83dc84863e2e55f299175c7e04a5902ae79cfb99d4249ee8f6d60a"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d47a7f33280fbfe3cb631ca61ab171a7ffaa47034d11ba319a3c3bb5b4f0f33b"
    sha256 cellar: :any,                 arm64_monterey: "0d591252ff07fa6aac8833b67fdedc5f1b32317aec3be57db3bb3f7b80e00462"
    sha256 cellar: :any,                 arm64_big_sur:  "0cfcd4a6778e9273fed09dd99bee8dff9912a7c3a008491fb8074d94809b8eaf"
    sha256 cellar: :any,                 ventura:        "182c363201a8a9891ec319080b61259a0849b2cf506a0f964ae016102ade085d"
    sha256 cellar: :any,                 monterey:       "a5bd790aa2431212bc81a2993dcff31e11a53601d4c0882c9c52ba92e6f16dd2"
    sha256 cellar: :any,                 big_sur:        "7653baa66df98b46cb5409303f92b6abb38d994b867c27bf3b4a474bc17469e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ccaf1d11b4b2120285c628d9b6b19b1e58104d7dc5a6dada00e0eab9936bdb6"
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "opus"

  uses_from_macos "python" => :build

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
