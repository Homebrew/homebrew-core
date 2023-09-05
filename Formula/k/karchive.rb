class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.109/karchive-5.109.0.tar.xz"
  sha256 "9c4a01c2e4190824e901d487aaa8ce6b2731aa8254fddd9c1a25ee1d1bbbc966"
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
    sha256 cellar: :any,                 arm64_ventura:  "e2d8d313a9e1b8e823194afdc1184d5c70dd11f3a71a321eebfbcdc6b8dd18b9"
    sha256 cellar: :any,                 arm64_monterey: "d071bc0cab03b1f52404b109bb93ae616f4f7b21e13159c1e590043ab8b43150"
    sha256 cellar: :any,                 arm64_big_sur:  "7cd7f9f03d4c5ef7dcad47e019b09b72ff1995e2b5628148629edf9251dd5eda"
    sha256 cellar: :any,                 ventura:        "b617e61d90e8c3d9e84b8abc40badfcf3c82e13cfdf0f2cbd3e9393434ae64dd"
    sha256 cellar: :any,                 monterey:       "9d72c864d8e0a6ec5d20216ae6578eb2dc619d78eeccfddb3c4360195fb49c61"
    sha256 cellar: :any,                 big_sur:        "81bb6b6b85de27a0b57a365341153f3ae21b2cbbf6d2cc100b72fef215a1a3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6384d86c851f2e889176970eb3a7b9604a7265344944ab74aa5b4aaf12354286"
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
