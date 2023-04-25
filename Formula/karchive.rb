class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.105/karchive-5.105.0.tar.xz"
  sha256 "77ef95cf4c525fe74261c7dd817564a35e726e5c1c4d1e1479fdfec187da9749"
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
    sha256 cellar: :any,                 arm64_ventura:  "25fe2de73cae570af12e8cc8fe26a6aef2a77430df0d72f8b30d3965a8270f44"
    sha256 cellar: :any,                 arm64_monterey: "c7e5b5461ed7b56713ca2a98e73f248cd9bea54f5716aae56014067cd555c854"
    sha256 cellar: :any,                 arm64_big_sur:  "1a553f108c7b6b6b16d593aa4b2e35e8e6482fa515191de8df1ef4dd6958c8e3"
    sha256 cellar: :any,                 ventura:        "314d2f1b60622fbfc0e67dbd4b649ed689f0bd9bb59c573ce31d4987ab1fd752"
    sha256 cellar: :any,                 monterey:       "47bad8540d4b60c6210ccf21fb23448a08e2fc3418fd6e911794e3d50d9f0e63"
    sha256 cellar: :any,                 big_sur:        "45b0fce136cdb5627e25f9d83016c889f77d60ae25a03cec6f3aae35dcd7b65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3c826bb97cd62adcf5787e073ff856b368b8ed1c57da7b29a2f7c64166c4d10"
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
