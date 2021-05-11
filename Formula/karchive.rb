class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.82/karchive-5.82.0.tar.xz"
  sha256 "b59821111c9419a746806044e8e0f16bd6be8c8f0eb3938f585aa3cee7dc4c8a"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 arm64_big_sur: "86a66fd97f0950647e3775504d184aedc0c00d2de8e3867fe5d7c74369ca1d5c"
    sha256 big_sur:       "397eff063d9c760337589af5f4e17a6d5f3e828a2daf034ce96b1cda3cbfd8b0"
    sha256 catalina:      "b0d71de3b380893bdd605d284415fb87dd6c07c130b2fd9139a1fec440d8bc57"
    sha256 mojave:        "eeced6ab7c926d935c694ac23a79f617185e04682022aaaa2aef3bdb3a6716bf"
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
