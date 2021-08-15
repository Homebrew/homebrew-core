class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.85/karchive-5.85.0.tar.xz"
  sha256 "8c196e9195485622c7e5f4523584e1e7551827a0bfbe477d08d34b7847ab6b2f"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e953c966c506cad31960caaf5ec0efa80e9838e9b5c3fd1e8d7f2db6ddac98a1"
    sha256 cellar: :any, big_sur:       "015849cad2e134bd237d540ec2d826a3c123edc7df372a15b26354b468314c20"
    sha256 cellar: :any, catalina:      "fa8f9898da6c8b890fb184b9199f27b26d3c9cfde6819506b80608a093e147a5"
    sha256 cellar: :any, mojave:        "1cd5c290587ee72d80ae4fe71106ea31e57fad1a683cc58331f5f3d8f7d61cdd"
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
