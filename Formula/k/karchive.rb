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
    sha256 cellar: :any,                 arm64_ventura:  "554bf87bc6c318b6508c07173bd2321ddb284e613fc3c4187e088dd4c40cd41d"
    sha256 cellar: :any,                 arm64_monterey: "b5b2a0941728c89b62d75804f824c7597d15f2d329e3737d4a2ee27fab2ea509"
    sha256 cellar: :any,                 arm64_big_sur:  "e67f45b726b2f62d7eda5663c6c9d30afca66d40465143fb606d8757d1296f8f"
    sha256 cellar: :any,                 ventura:        "0d540a3bf82150b29b4ab3e717af7e07efa1cadd0ff7df5e13ff31433014bc8a"
    sha256 cellar: :any,                 monterey:       "aadde4c78d6b00fdda38e98dff55a577aeea8a88b4693e65221b4b957b95af82"
    sha256 cellar: :any,                 big_sur:        "3b4448543fe7dac7444a6d3b22a54157c9cadee02657d5633e07a5f7aa4ea6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a77baea224eec7a52e2da5f845da5ffa500531d2d55a3541af8c5706a0b7f5a"
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
