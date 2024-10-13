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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "10ef77f1b249abb5012c6bfa498aae3786894e4c4c475dfd4ac14a14562fe1dd"
    sha256 cellar: :any,                 arm64_sonoma:   "0e8ccf402d37e1be344af315c4b06c5faf3fb1307bce6d4a79d198ffbb9d2ad0"
    sha256 cellar: :any,                 arm64_ventura:  "a78c706387bf29a9df4ac87f6642334d92191fd641d868a15058e98ebc5d62cf"
    sha256 cellar: :any,                 arm64_monterey: "ff1229550d6d68c6de3258942addae073a9a6ffcfbd350716ada06a2573fb9c0"
    sha256 cellar: :any,                 sonoma:         "95febe4d68e594a59a1b2d12e835263dd71bcd62cef9ba822ebc7c38c9142f28"
    sha256 cellar: :any,                 ventura:        "0e4063508906f9adbd3cbae4abb6e20aba8b529631300a663d6ab9ef3e3095af"
    sha256 cellar: :any,                 monterey:       "608f24002de2227bbc10e170cc4d4d47d077981530185db47a98c25ad9f1bd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208e7c63412df3a225c37c7305acf39a1eddac9e0983950051f937ed74960fbc"
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
