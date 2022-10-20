class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/karchive-5.99.0.tar.xz"
  sha256 "571957caf8304344ef3d5b47092be96563e1526d4a1d70abf04ebcc38dd495fc"
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
    sha256 cellar: :any,                 arm64_monterey: "343e020d207c3ba1057cfd3ce15522cf881aaba4176c0472e65a02b6e608cf7b"
    sha256 cellar: :any,                 arm64_big_sur:  "b52d1d62436604e88b304a7eeb75bee582b16736d3be94fe4053ac77af86ea03"
    sha256 cellar: :any,                 monterey:       "ede29ec5871764de2812088982d0920ea41ce8e3d67c47342a1b558dddd991ea"
    sha256 cellar: :any,                 big_sur:        "e26b3dae4ca39b63f6a95550a3359f4064f4a80739e82047b6e356f1d44257ad"
    sha256 cellar: :any,                 catalina:       "d67068f2eee4ed65c0f2cd676a98e856ded2993bd94cba94f173d955a55b8c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803a9e5dca7e4da15425d3895ef224638464664ba618b8dd697a9ea15d294eb7"
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
