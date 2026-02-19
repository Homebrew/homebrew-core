class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://github.com/folkertvanheusden/HTTPing"
  url "https://github.com/folkertvanheusden/HTTPing/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "87fa2da5ac83c4a0edf4086161815a632df38e1cc230e1e8a24a8114c09da8fd"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/folkertvanheusden/HTTPing.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "071348d10108c95a9cd23e105942b81e63fbd1caea8f2367427a554f406b68e4"
    sha256 arm64_sequoia: "b6188bb2590af36f19f4f7d2fdee0004bc740cca357770f823eace71fd576195"
    sha256 arm64_sonoma:  "194a46abe5b4fd668eac0dbdc42d94e72b84dc7abb6fb75b180cec07f03dfda7"
    sha256 sonoma:        "aab01cd51be36a661adb1fab505740b3cdf0b156e13d96ba6886e1389761bf1a"
    sha256 arm64_linux:   "3dfe264e40fbf0b9759dbb72b968bc9b3a87fe01f8acb603dfab8d285880f509"
    sha256 x86_64_linux:  "51e8dc57762f328e29329501734ca6e2b9437a69613abcc68830cc4fcf13bbd7"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext" # for libintl
  end

  # enable TCP Fast Open on macOS, upstream pr ref, https://github.com/folkertvanheusden/HTTPing/pull/48
  patch do
    url "https://github.com/folkertvanheusden/HTTPing/commit/79236affb75667cf195f87a58faaebe619e7bfd4.patch?full_index=1"
    sha256 "765fd15dcb35a33141d62b70e4888252a234b9f845c8e35059654852a0d19d1c"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DUSE_SSL=ON",
                    "-DUSE_GETTEXT=ON",
                    "-DUSE_TUI=ON",
                    "-DUSE_FFTW3=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = /HTTPing v#{Regexp.escape(version.to_s)}.*SSL support included.*ncurses interface with FFT included/m
    assert_match expected, shell_output("#{bin}/httping --version 2>&1")

    system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
  end
end
