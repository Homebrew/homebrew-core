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
    sha256 cellar: :any,                 arm64_monterey: "6bc52439563779a1e05ffc67760c187f0659a70035dffc24cf75bb714cc4dfd4"
    sha256 cellar: :any,                 arm64_big_sur:  "e7a824b47579de35e1bca39be42d734ba74ba2720d01671e43f4f094aa38f544"
    sha256 cellar: :any,                 monterey:       "153947e0dbf51534f2a6078e518b44191d82aec2e31173708b259a6dad5c3f86"
    sha256 cellar: :any,                 big_sur:        "fd4bc921e798232204a799252be921c7f4b47dc90a01c6ce292aa13935a1b39d"
    sha256 cellar: :any,                 catalina:       "bab04ba17dae7b50bda5c51e2c54470a257797f73e8e55a2954e2292a644fc0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e3ab23fd759f0a37bc2a52990266d92eb17561fa34822ee424bbcec0018ae3a"
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
