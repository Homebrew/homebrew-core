class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.103/karchive-5.103.0.tar.xz"
  sha256 "372bdf691ddc43e663b5c6ca88b2c73fa0fac9ee8e3600b469f9b026c8dd1353"
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
    sha256 cellar: :any,                 arm64_ventura:  "b0ea5397f2f3b9f063c84ba16d5ac4573280a22a18e44322c0ddf80d5b6eae06"
    sha256 cellar: :any,                 arm64_monterey: "f674c11ab0f741ff4119ca12e0905ff5bc9e4436747cc9c91e1c1f62dcebaf13"
    sha256 cellar: :any,                 arm64_big_sur:  "bd796bcb86f59545a2260e157ae1dc15c54a40d2464ea42e25e59ed8a60bdfc5"
    sha256 cellar: :any,                 ventura:        "4517c1733091e3b83ee7a55956b0ad337ae1a0a2beccfabd1a9997717be72fbe"
    sha256 cellar: :any,                 monterey:       "e673842aa495406e97140926b3f1a4141931075c9808ddcb3e1a3421aceb4431"
    sha256 cellar: :any,                 big_sur:        "1ee0174b0912f763e9249fff50567f4ca42278e20a1ee7e0e2fdf14b7640011c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b93f591164856c843e66692377fc7cd3e5e4dee40240b02380fbf2673b2f5fc"
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
