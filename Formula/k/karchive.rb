class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.18/karchive-6.18.0.tar.xz"
  sha256 "fa24f703aa799e4ff5b9cc2e4a628745912ebfcc9f0c6bb6d92106ff9e02e26f"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7d1eff35b7f4cc23f060c0702ad725f9a251e23852da8d6ef6f3b2aba2abd600"
    sha256 cellar: :any,                 arm64_sequoia: "1b2fbb2368d8522731a41833359568fbaa1920fbcdf0ba53bcb4024885c4f8fa"
    sha256 cellar: :any,                 arm64_sonoma:  "966c7c2c9bb5735fb891c0e3c87061af05fb19ec9afd1c78fe97397fc47df5c9"
    sha256 cellar: :any,                 sonoma:        "103f540e8a8c6d3c8e8559c7176af2a174793eb3079a7b29fff0652043e776b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f4769bf0f3c018c47ed3d59c956204ce51f39e0d0682ea699801d70c604c53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b67787820d0472d369ba9773823077558d47031051d2203c9fcdf7d2ba0ebe3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "openssl@3"
  depends_on "qtbase"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples").children, testpath

    examples = %w[
      bzip2gzip
      helloworld
      tarlocalfiles
      unzipper
    ]

    examples.each do |example|
      inreplace testpath/example/"CMakeLists.txt", /^project\(/, <<~CMAKE
        cmake_minimum_required(VERSION 4.0)
        \\0
      CMAKE

      system "cmake", "-S", example, "-B", example, *std_cmake_args
      system "cmake", "--build", example
    end

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_path_exists testpath/"hello.zip"

    system "unzipper/unzipper", "hello.zip"
    assert_path_exists testpath/"world"

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_path_exists testpath/"myFiles.tar.gz"
  end
end
