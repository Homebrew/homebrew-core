class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.107/karchive-5.107.0.tar.xz"
  sha256 "e88cb94b9af8a88f360e627b3ae7a2b99ccdfe3fe9e1961452056b2a00f04a7f"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea4140ce717d5df2c2d2927d69b0c7a0428d817b67a9ef05b0043beb37249bef"
    sha256 cellar: :any,                 arm64_monterey: "0eb935e2cafeb2437fd03cac159666a2fa07c0efc86f38b7f6d05f2911a4ce5d"
    sha256 cellar: :any,                 arm64_big_sur:  "ad1265c7be88b9643706e32e3cc8ff377de255b975c8078d422b58a39ead91a2"
    sha256 cellar: :any,                 ventura:        "3eca247e7cd1dd1084a417ca30e17e85c4f60531bcc6769a7eac7e0902092622"
    sha256 cellar: :any,                 monterey:       "f6f25e26e131bca4fa4d99b7cd34823ff4e70071dc411e6146393972ad01cc79"
    sha256 cellar: :any,                 big_sur:        "764980baf4997bfbb3c418b38287f35bd79d521fdbc23eead2d2edafc64e4f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66b09d4229d348bd027998fe5ac00592bce9b3ac497635f96b14a6fa99ffe019"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args + %W[
      -DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core
      -DQT_MAJOR_VERSION=5
    ]
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "cmake", "--build", "."
      end
    end

    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end
