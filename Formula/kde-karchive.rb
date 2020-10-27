class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.75/karchive-5.75.0.tar.xz"
  sha256 "0c833c766d2301335490a1b36197bae20b2e45d1350f4f8100e6e00d5502eaab"
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 "81b11c149a78c9d533ea468fe8017dff2ad9313f8e67b8dcc2b753503ced3c20" => :catalina
    sha256 "bf813285477db9b6a450f3238b9390c1ecf1f9df62c039cb647bca035b9ff7dc" => :mojave
    sha256 "afb67439b3d87b56b87664589a2c051916f85e45f58152532f4ea005859f86e1" => :high_sierra
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
