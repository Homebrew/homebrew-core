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
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 arm64_big_sur: "baf0ff996b0348a9fefe96f0978d89de771897e2349e88d51142d71c87a02040"
    sha256 big_sur:       "32aef8e4816e73ce9c6b7e8a41389202c628e75fbc6642258b75ccc1cb36ef80"
    sha256 catalina:      "9e3b16e67d92c42ed4cbcb8f637760e5f2474bdd886c81a5e88598f61550eaac"
    sha256 mojave:        "2a04ddb84245f2d52de55a13d0ac8ac555a42e15e081828dcb17dda281153889"
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
