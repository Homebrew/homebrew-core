class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.83/karchive-5.83.0.tar.xz"
  sha256 "5ca9953951a778f759c04cfacb8bbc1e103a9cafabafceceb3d25568b3a2e379"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "190de292af271c60f358eae36a4a72a8aef1848fa19cbfb2683116a71d0f286f"
    sha256 cellar: :any, big_sur:       "702867a13a203f79d76eadfe8f62aa86c5e3ae3b3661dfb22c12ef9340c88bd4"
    sha256 cellar: :any, catalina:      "793f77be4310d9d9f949a203d5c9cc4d8c3b1d625206b0deffa02c0830fdcd21"
    sha256 cellar: :any, mojave:        "04a2ce817c1d4a3db9be9f0094ce3b4563dd1d2a594fbc224c72830b63e31148"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

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
