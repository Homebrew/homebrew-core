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
    sha256 cellar: :any,                 arm64_monterey: "d668c023292e8ff898acf076654b0f8d62f3b2cb2e45a7d6bbb880fbcbefa9e0"
    sha256 cellar: :any,                 arm64_big_sur:  "764eb13b4d3f3e113e29e5d4c9681564246a791f6174ab4d0b0d55cac7ffbf2d"
    sha256 cellar: :any,                 monterey:       "2522b26c1c0fc167587fb1d4d70da248eda42c1c7e4f7f2601ad323448b41b96"
    sha256 cellar: :any,                 big_sur:        "bd34cd5176907260341ced01edbfe9301974c22bc66a5d4ec749a997b6ccbe47"
    sha256 cellar: :any,                 catalina:       "4b02de3300446f730c2e7de48e52e0e4949b4e83a57944d1299e3eb8c2c7503a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603c6ea19a96dc3a66ca8beec1c283be722859baa1c4f0ffd0e38dc2ff57dcd8"
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
