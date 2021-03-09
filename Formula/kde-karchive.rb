class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/karchive-5.79.0.tar.xz"
  sha256 "0cd2bf46cc476b8b56138b3a892688ab70d0ddaa9739350a7421dc77a6210e07"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  revision 1
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 arm64_big_sur: "0b3b535f5402de3c1885d2064e1a56ad9724cd3cb9b03b7095bd1ace63f9c877"
    sha256 big_sur:       "3e1b0e3b53f2879ba8eb38a04ae0b8530c26f6d411c45ff87366e4c55072e671"
    sha256 catalina:      "1c0dfdc9b341296e4d6f3732207a6fd81497d9573471542ce1d0ea546c0ff435"
    sha256 mojave:        "e8f81aeae13c7b409fb423074ed50da2a752e0ad7694921665f59e91bc9996d1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]

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
