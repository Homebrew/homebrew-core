class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.98/karchive-5.98.0.tar.xz"
  sha256 "02c7c60c35c9ad0611d70be3186f017a716c201a51de8bc137e5191e833cf2c6"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "a2de818dc3cc8dcde26aadf4587921ca186bfa5fb5f88a9fa90e940081636427"
    sha256 cellar: :any,                 arm64_big_sur:  "472e96063818f7cd08414df483b057e16fa5409f80b0f5a023ad71cc1df30300"
    sha256 cellar: :any,                 monterey:       "1666cec73015d49a24e4b501e08b8f2c25777bdeb8a60ceeed9a4bf0d2546c7a"
    sha256 cellar: :any,                 big_sur:        "d8c125a0c6827905056ff233367d296315792218eac1f20d807d7205d408b45e"
    sha256 cellar: :any,                 catalina:       "14736b595f81734e1872e4b342bd60ad1fd22b659caf9beb7b25560037484e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad2078570a30de54c5c9e5d548a81033de5ac04dc7f87946d42681697217451"
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
