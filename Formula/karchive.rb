class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.101/karchive-5.101.0.tar.xz"
  sha256 "58bcb6c61bc4a3fe48a0cbeaf392d42b6b8d33e1bc4c51faf24db0912ecfa9b0"
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
    sha256 cellar: :any,                 arm64_ventura:  "222afc155e6c187e7aeb00932c9e4e09f5aad3f9ff0b56380b7a45d213cbee4f"
    sha256 cellar: :any,                 arm64_monterey: "a22978e218a3034d1ed5740a94cc272e6ce61f7a5edd103bbfab08b4425d5a28"
    sha256 cellar: :any,                 arm64_big_sur:  "37c7143acef642993aed5995edf773227cf2a147e043ff5c68b12df96f7d2a6b"
    sha256 cellar: :any,                 ventura:        "32d42f0d4837e46463bd43b50e0cf18cac85f218db4aac6d792fa6b6261706bb"
    sha256 cellar: :any,                 monterey:       "353caefcf5d39691951ce2f158e1dc24d24278b423c9b902556e343ace3b2cfb"
    sha256 cellar: :any,                 big_sur:        "cda0bb66b6a25d665b99bca6ad2711a8219260ca70d96e12016a9bdc0345005b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7c9d50284184a7b1558f8bd74a6945d7abfa0a26f7ac808fd8a41802a4034f"
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
