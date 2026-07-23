class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.28/karchive-6.28.0.tar.xz"
  sha256 "ff36137e6b171906b4bde4006558739c5d7771dc30b9a037b65e62b2674a1b13"
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
    sha256 cellar: :any, arm64_tahoe:   "4e39e007daeb3484fbddf58e0da2b058e51e5fdd030a32fd3f4836105fa3f504"
    sha256 cellar: :any, arm64_sequoia: "ec78d8badeb96d71e8df88567c60a9a457ae78cae1e1f36a4dc0b9507d254d2a"
    sha256 cellar: :any, arm64_sonoma:  "0727baef6cf15e09bc598b6835445f652b4065feb04e4fa4d5b41440ccb24d97"
    sha256 cellar: :any, sonoma:        "e1b38f6e02c7dfbd0534391530c058df59deaea0fe425ca6cd048632494601b0"
    sha256 cellar: :any, arm64_linux:   "e6c4c46f56b0c3a55c6e9789ae110da0f3d2f90576af1d5b97d39d7d6aa09db8"
    sha256 cellar: :any, x86_64_linux:  "d1cd7c859abcd1a724f61f3583feb6705215edf3e7adcebd4623dffcea98c4d8"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
