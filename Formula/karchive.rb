class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.90/karchive-5.90.0.tar.xz"
  sha256 "a6e2f3a7cb1aef7db7b4f7dfb9ffb1d929d0d5b147c25a93fbc0b794dfcd2110"
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
    sha256 cellar: :any,                 arm64_big_sur: "61bb367fa37431e494f85002d94a3f4d7c80d4cacf7b87568b6bf4961e06b62a"
    sha256 cellar: :any,                 big_sur:       "e267092e60f439ee6a0e17b7e8de1530d90a42f22469b93427878724022d6fc6"
    sha256 cellar: :any,                 catalina:      "aa1cac36753a2af0b99fa2abdd2802a91c7ba713df964950a342026e9a6fef42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad0ed90e9bdde5d55a3702c674e51ecc4a2f08b87c51b21c8a12b7dd83dcd93"
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

  on_linux do
    depends_on "gcc"
  end

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

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "make"
      end
    end
  end
end
