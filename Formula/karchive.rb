class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.95/karchive-5.95.0.tar.xz"
  sha256 "1e8cce20bf1d0451ea216a83cb79609fc5e447f009f96222ebcabc799bcdd549"
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
    sha256 cellar: :any,                 arm64_monterey: "04a1f5df66032f074ce6df7f216018bf7191274a6820d97c19ef4265934b566a"
    sha256 cellar: :any,                 arm64_big_sur:  "d7bd84267ebb51c5378a48b74cd3ae316bb2ff162612ac7cd3fa9db03e0db526"
    sha256 cellar: :any,                 monterey:       "cf2b2275e053b65e8cf6ae0f9bf2ed168cf5d2d25ee4f4151de9ddf292da1830"
    sha256 cellar: :any,                 big_sur:        "dd373586c2c4f43bdb186a8892d52eac79905b1bf958784540df43a6944791f3"
    sha256 cellar: :any,                 catalina:       "f1c589a2196fb24f12432817f4667293c9a6dbe65f5e613c0f1c9b108642cb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc4bdf593b50a1568544054fb71ea8286a99df1a2d2edfa27c4db5b59c35044"
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
