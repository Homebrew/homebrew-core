class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.77/karchive-5.77.0.tar.xz"
  sha256 "2239af811b9205d9f4486791f4b25ff5ea299b3873021a646e1c8b9d44c2be36"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 "f39ebedb09a7ff73fb590dec5d9b86afb1235062c312f9764c03e077d56b7be1" => :big_sur
    sha256 "022a12af7a7b3d74e9942dd9bb3de579e91f5658a0fd2932ad275b50cd998a7e" => :catalina
    sha256 "d5aa2242ed47a820469d0a4241bc88b0e07a90d593e86a1137e8e36dbe0f1f4f" => :mojave
    sha256 "d415cb31636208456779f46fa711ba67e2da0d060ee94960173d2d78879c20c4" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]

  depends_on "qt"
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
    args = std_cmake_args
    args << "-DQt5Core_DIR=#{Formula["qt"].opt_prefix/"lib/cmake/Qt5Core"}"

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
