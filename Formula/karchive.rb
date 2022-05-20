class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.94/karchive-5.94.0.tar.xz"
  sha256 "55cd87a5437a649c168efbce4af132b992aa67dd9a3a8ced7cff0144f155e1e4"
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
    sha256 cellar: :any,                 arm64_monterey: "2ab075e76cd994ee521aa11657d0472959e8e4bbf82d700fa1cac385e338dbee"
    sha256 cellar: :any,                 arm64_big_sur:  "0e8e70887dbcdb0b7697c98bb3e7a231151bd65a4bb1fab63240b0c08aba11fd"
    sha256 cellar: :any,                 monterey:       "1785910d0be96699e328f44b08a4520a2ece36cc3668023c54a4e35754f4cdc0"
    sha256 cellar: :any,                 big_sur:        "bd36f7a3890ff4bd0e9fd22ceeb3fe7a89ac28646e4928cccedb5451277fa3a8"
    sha256 cellar: :any,                 catalina:       "c475bc20dfc047c0b3b39a19900da77c73d9dd833b494d57897a86c3a23d06e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b7df4c8bfe2197d70f45d9ba2a029c5ec7e1bf15e71feee7176f6862db6aacb"
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
