class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.1/karchive-6.1.0.tar.xz"
  sha256 "576c7133cfb994b530bd7377030b926bda227aa2ae420d5d8538f2681926f82c"
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
    sha256 cellar: :any,                 arm64_sonoma:   "958d08511c1da155cda4794301c6f689ba4530d2572101ae7af0ff52576c8049"
    sha256 cellar: :any,                 arm64_ventura:  "b8ae4b235b9c9b1e63d27f3f9ce9e86aefdf37e5df69d9d94d355e430b316129"
    sha256 cellar: :any,                 arm64_monterey: "23052056ca45114d2f158758c50f527919e6976a67f54ab71a8ce7338b86be20"
    sha256 cellar: :any,                 sonoma:         "5fb929641a9c311b11edd956936a3962ed10c7e4057b22dab1c2fca18ac771e1"
    sha256 cellar: :any,                 ventura:        "59dec26847501b2fce5ddfb96f6ec0cf90650f50b73baa9e5de609c7c3130d79"
    sha256 cellar: :any,                 monterey:       "491fe1def0386bc4b92319108eb9488f9b8f923d709796118caad8e034565742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c118265ebff536104764a8567269cbfe02bd0f83ce69c11bd03c3e0be8a4f3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

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
      inreplace testpath/example/"CMakeLists.txt", /^project\(/, <<~EOS
        cmake_minimum_required(VERSION 3.5)
        \\0
      EOS

      system "cmake", "-S", example, "-B", example, *std_cmake_args
      system "cmake", "--build", example
    end

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end
