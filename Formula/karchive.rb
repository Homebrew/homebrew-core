class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.97/karchive-5.97.0.tar.xz"
  sha256 "1bff8249ddbb5a38916c9e145e5027de3f18a14772e7a8bdd4a954fae7ca8d92"
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
    sha256 cellar: :any,                 arm64_monterey: "964497340ccc206c38a97c58249ab08196df8541c8896c076ec150b81723c20b"
    sha256 cellar: :any,                 arm64_big_sur:  "3040f6d149cd9878462d34caa3fc7d6c1bcd81469fe6f041eb4056545f83fb0f"
    sha256 cellar: :any,                 monterey:       "d67494f70606261c3e62989547433a8c5ef9bab83eb0df4cdcae535a5d626d93"
    sha256 cellar: :any,                 big_sur:        "0edb2ce3c3d7bae30a9bb3cac5224a29d7a9316e5caf232a07839dc03f07d067"
    sha256 cellar: :any,                 catalina:       "bb6f03b1e3a9ad17d13c512ac507c4264979b55b9d2be1f79ee73052b6386e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1fb51b0fe59a49559a2a9e705d2414c20329e8956632eefd171993a524c6bc"
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
