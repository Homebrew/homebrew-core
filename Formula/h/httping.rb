class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://github.com/folkertvanheusden/HTTPing"
  url "https://github.com/folkertvanheusden/HTTPing/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "87fa2da5ac83c4a0edf4086161815a632df38e1cc230e1e8a24a8114c09da8fd"
  license "AGPL-3.0-only"
  revision 2
  head "https://github.com/folkertvanheusden/HTTPing.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "7c3aa6d130bc657c32526f90b94cac8847c38d58e0bee1de4efa0e61926afe88"
    sha256 arm64_sequoia: "097832cdd90f95bd5223ae4f8d0be9e358dc9426f9c19a50da8ab9961e9b2687"
    sha256 arm64_sonoma:  "f48b8ef6384fbfb22e1b280d7b58752c460c7c64957d5c1d6bc812d732bf3993"
    sha256 sonoma:        "61a7c0088454490720268cf9899bc187fb60e7efef09c2df902e332f001d6eff"
    sha256 arm64_linux:   "c95e3c70266f25435d4c4a57c42667da305bb123b2fdbcd62662f830cb88e34b"
    sha256 x86_64_linux:  "9bf1087b86efa6a82d2d625782eec4c6b8d0baa81075d0afd1e9dd9c08a575fa"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "openssl@4"

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
