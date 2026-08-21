class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.29/karchive-6.29.0.tar.xz"
  sha256 "3d66cd9d71fbbebc3cea68757111002666b366898b01178b6fa7203715574287"
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
    sha256 cellar: :any, arm64_tahoe:   "2c4d86d366ae7449d72c16fa95ab78ee98ba345d57a602e10cb6782976a45b2d"
    sha256 cellar: :any, arm64_sequoia: "9f678f8905d81e2989db998e3844f6bcdf8856546eb93360d447d8bd24106143"
    sha256 cellar: :any, arm64_sonoma:  "621bc00c2882df9f57373de2955d4d46303c6a8089d9737e5f93a814d93ddc9b"
    sha256 cellar: :any, sonoma:        "67e21e9e35391025fc62f9dd4d98b8cec9d264abdc712947f04ddd998cc46afc"
    sha256 cellar: :any, arm64_linux:   "288ae288a342f3ff127e5e81dfbf4f5e1bad969464a98795426431fd34bccad6"
    sha256 cellar: :any, x86_64_linux:  "7e7809ff50a690aad2d3d061488a95fec7ea34b22797e15f8cf8a59e881f2568"
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
