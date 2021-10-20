class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.87/karchive-5.87.0.tar.xz"
  sha256 "103f2e8a60b50683ed626d3c9c29c99ced3c55d20a9f5d1cfd0a576e7dc61c35"
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
    sha256 cellar: :any,                 arm64_big_sur: "382cd1e7c986caf9c193a509ec7e08eeda49e38a11caeba1f9fb38f777a8db36"
    sha256 cellar: :any,                 big_sur:       "9dbf24b216359a30749add98de038853aeea7ade8156d25160cde8f941c06d7a"
    sha256 cellar: :any,                 catalina:      "3acce027ea727bb256609b05a127eaacf5234e8c57ae9955669120c27bd1fb1d"
    sha256 cellar: :any,                 mojave:        "4509c01f7b0b035da8bfee3760330747de6c5f5916a353855d12516ec166c9e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc62619c9465ebd022aedfbf0b8f7296a43500d5da1be6e488dff59f4c6248b3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args
    args << "-DQt5Core_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5Core"}"

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "make"
      end
    end
  end
end
