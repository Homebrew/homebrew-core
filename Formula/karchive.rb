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
    sha256 cellar: :any, arm64_big_sur: "cff0b43cc34e109a59f67fedafc5325408bb30e7c4861698cd75230d78601147"
    sha256 cellar: :any, big_sur:       "ad7ca9c36b890ec338a8a16e3dff25385c8c798b6e7394815d8ac024720e3aba"
    sha256 cellar: :any, catalina:      "154d033854ebe6854567630d01fb28ee89d6d7d050e28f57c9e4b009a23e0379"
    sha256 cellar: :any, mojave:        "57e2873cf02c1692fa42f22b1ad1425b39899cf44e8a4acdbd5e279ba93f6c08"
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
