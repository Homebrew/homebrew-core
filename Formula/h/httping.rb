class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://github.com/folkertvanheusden/HTTPing"
  url "https://github.com/folkertvanheusden/HTTPing/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "87fa2da5ac83c4a0edf4086161815a632df38e1cc230e1e8a24a8114c09da8fd"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "5895bed583e9faad9d7be382a6890f92ca1cd229729977729246a0b3b8603597"
    sha256 arm64_sequoia: "2edf3ec3576fcb84bcd40124d94c84e80fedba5975fa7c22aa30375e40ab48c6"
    sha256 arm64_sonoma:  "f51c8f88fcfdf499b9402d73c8e694395f1ee09af0a1d988774f02cdd7ae9fed"
    sha256 arm64_ventura: "cd0bd242c917ce8ce4699733fb6bd36cfccefd36bd8b0b7fba4822842601a351"
    sha256 sonoma:        "5c887df378bbfbe24b8049e579a6325bbd7d8cba076eebe392ae3dab8dd6f832"
    sha256 ventura:       "12e2cbfeb500c53bd2cde0ec98d9426a9736d4a40cce70035869b5220108ff6f"
    sha256 arm64_linux:   "21a1a7426bddeb581154982e0752a0a745069893d7fb04872e2700bccb8a26db"
    sha256 x86_64_linux:  "d216d2e231fe96782beab3f205156d657da0c91f6c6c98e2a2ab1218a1db0f33"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for msgfmt
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
    system "cmake", "-S", ".", "-B", "build", "-DUSE_SSL=ON", "-DUSE_GETTEXT=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
  end
end
