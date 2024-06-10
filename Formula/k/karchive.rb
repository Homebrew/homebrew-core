class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.3/karchive-6.3.0.tar.xz"
  sha256 "27807f5707668f9aa41c898eba90198a3083577fdab9f4751a02fefe63674e29"
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
    sha256 cellar: :any,                 arm64_sonoma:   "78ff00cfb5f0b5aab127d967adb3af457392d4a0009b538f655cb752d5da6dc7"
    sha256 cellar: :any,                 arm64_ventura:  "fabd2fe53f721e72d6b6430c89e3f75e3acdfea45f69a61a80e57b375b2862d1"
    sha256 cellar: :any,                 arm64_monterey: "2304834f23564beb37fad138e27d34997493d58f8a50e6b8dd7253f2bb3ea2f4"
    sha256 cellar: :any,                 sonoma:         "5a2577727be35745045821952271aacc7a02611899d49fc03ca664f0bc7de141"
    sha256 cellar: :any,                 ventura:        "73f0d5456ff054982172abcaf9415825be49b928c0467400d00b997edc02b55e"
    sha256 cellar: :any,                 monterey:       "88912c78274e92ba177fa8644e48f2340193ff7557c02e94b5a09245c7bd876f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "894aa04b9654721b3353fdaf711eac85ad34ed4b6ffe1126d8e13b29bbebe62b"
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
