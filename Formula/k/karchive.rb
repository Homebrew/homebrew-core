class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.115/karchive-5.115.0.tar.xz"
    sha256 "e89951c58beca1f9802b9a3a8b8b2beff9b534d2de433ad7947258dd27d6b475"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06ff3d8ab813b89a23d09ac19cf2ec0c4b28926312ae16517dcc913b12491ff8"
    sha256 cellar: :any,                 arm64_ventura:  "61ed11fee5d6f3c182316c86d92b09dca40990d8c57d09697a16130a437ba0ad"
    sha256 cellar: :any,                 arm64_monterey: "ef90a556aed83c4c12180bb8c181fa003effdb6370a7f10d5014e75a15d07b6c"
    sha256 cellar: :any,                 sonoma:         "8c920762159f58083550387e9a5a6d2f6937da929abfb34b7c8d2f93799ea23d"
    sha256 cellar: :any,                 ventura:        "582d372caed1fcc6e7ed1eadbcf834428b0392168a068edc93aaf56b58ba7b0e"
    sha256 cellar: :any,                 monterey:       "1bf15111ec97b3f04d18e056371a2207f1d04755a11f20bcb413dcdcff6b2a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85386f99944fb030743db5b0e2042dc1aa4b62d57f6ff2122022af1134f9c755"
  end

  head do
    url "https://invent.kde.org/frameworks/karchive.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build

  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
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
