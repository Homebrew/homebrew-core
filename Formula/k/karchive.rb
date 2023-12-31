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
    url "https://download.kde.org/stable/frameworks/5.113/karchive-5.113.0.tar.xz"
    sha256 "2da489460198e4c9aabe4734793c97290ecf08f789160fae639ef40a0bba430d"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34c4931a94461a10bc2630405df20ce2a170a098b4fad8df74d288f4fb95f6f6"
    sha256 cellar: :any,                 arm64_ventura:  "e0c810e268ad0ac4e229e7cd517289a9e045fb7fc40914cc46bb81de34069390"
    sha256 cellar: :any,                 arm64_monterey: "0d3b6d46bddd0bfcb984c4db7fa10bb08fb97ac8005b67bc96c802ab742ce443"
    sha256 cellar: :any,                 sonoma:         "2021c923455526fe9e838cdee16d41595d2e986aee06e7732c1bca7403e1ba56"
    sha256 cellar: :any,                 ventura:        "6ec4474b8608ae49272652b78e2fe633cc0430ef7d4ea2c7c07dab52e7b54c2f"
    sha256 cellar: :any,                 monterey:       "e7e46377e212e823ca64a44c588117be41ed6278d3356b7bad5db1d2f12c7fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5f996a7fbee468ac5683b09da5eb1f1e01b56101cbc7b2a29c0047c357aa477"
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
