class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.106/karchive-5.106.0.tar.xz"
  sha256 "fc1e5a8e94bb000ba30a5e7ba975126363c97acec98112ab58aaec1069d5a596"
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
    sha256 cellar: :any,                 arm64_ventura:  "d109bf0e30daa837458a75f20ac7a3613d141960787ed2dcca5273d815eb069c"
    sha256 cellar: :any,                 arm64_monterey: "8bd4e5423a9016a22f53e724842d4e74a4b26cbdf041f238447ecb83f47bb296"
    sha256 cellar: :any,                 arm64_big_sur:  "e73c9356631a09de8a6451de621707578b6fcc6d7e37a3313193b16c397492fb"
    sha256 cellar: :any,                 ventura:        "bd3ac35aa7d921bd4d43b1eaa09be8693345294199ec840ae10eb2cc18170ca9"
    sha256 cellar: :any,                 monterey:       "68f70679d43879a326e2910b319feebf36649f809e059563c16452c44d6f625c"
    sha256 cellar: :any,                 big_sur:        "248387d29028ef4f1d24d863883b4f22cdf95d4917c3cc3bbe2ea14c8d03b071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c67007915537f7afbc21f28ebb9cc1fcb588c78b83c4fc89f49cb0feb1bd952"
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
