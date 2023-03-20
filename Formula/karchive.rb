class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.104/karchive-5.104.0.tar.xz"
  sha256 "b62f3dfe68691ad2917d0592d66ffc02cfbcc7571b7d1fb1d3fadd695534fd2e"
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
    sha256 cellar: :any,                 arm64_ventura:  "9a7404999daf5fc462bc5025086276104d56ebe23aaa71239e119c34b71129ab"
    sha256 cellar: :any,                 arm64_monterey: "8156dc46f365c569ef5ce8a7c946118ed76f1230d5cf02cfb0f01390f5a2548f"
    sha256 cellar: :any,                 arm64_big_sur:  "9ee583b83a83e36720fb7151178f43090c51cd035e45da4a903e7a3d77318988"
    sha256 cellar: :any,                 ventura:        "b86549b80f9bd375e7cd566f4eb646081d3d0b2646fa2a35d0da2bab6e397c13"
    sha256 cellar: :any,                 monterey:       "865f669e0ac1bf2877f0de2b6554cdc72b90e701225ff906f5aa6faeb88b1693"
    sha256 cellar: :any,                 big_sur:        "2d6415793cb96f36d06a4a6387f32002979aa66e1d858c24c665d99c50c25fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266b8215aa987b520bcc97edfa1b00a9fbff7541bf7b07a83f21e5501047061b"
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
