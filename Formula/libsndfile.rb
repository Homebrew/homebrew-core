class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.2.0/libsndfile-1.2.0.tar.xz"
  sha256 "0e30e7072f83dc84863e2e55f299175c7e04a5902ae79cfb99d4249ee8f6d60a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "613bc9b6aa39f97f5b96f8fde4eb326d86b84eefe834bb4390525a27394920ee"
    sha256 cellar: :any,                 arm64_monterey: "3a684c2f61724acd97267aa7663871debf68cfa90e5c16205add3e4a3ecbdbc2"
    sha256 cellar: :any,                 arm64_big_sur:  "b1d790d532e030e237f8a2cc107d7f89bb9770777dcb3b539f2d25dbe8ca375d"
    sha256 cellar: :any,                 ventura:        "006bfec19f53d52e3fc5124368e28047e4dc93d4eeadd5c279214cbe0bb8f45f"
    sha256 cellar: :any,                 monterey:       "1f7d0cd31198a65141994868ff9fb38a9b6461e9ab0de5101df721ebb39e8b6e"
    sha256 cellar: :any,                 big_sur:        "df6c7be8e1ed21ba93dbd54a5ebcafe52240427cc3db497755d45222341128b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "999459d04493b8d24126025e3b954d0172bd89b38cbb92072a4ce993ce320d68"
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
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
