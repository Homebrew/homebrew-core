class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.75/karchive-5.75.0.tar.xz"
  sha256 "0c833c766d2301335490a1b36197bae20b2e45d1350f4f8100e6e00d5502eaab"
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 "28cdb99cb76a6b82e9aa1800b3c69e116d1ef6b4266ae56045ea3b7cd9f8a642" => :catalina
    sha256 "4ab8590963fa77fdf7d715d2126a1d7460c6c11ce1936a288846d9fb3d495223" => :mojave
    sha256 "10815dac0c11c5a9a44584ab3ab6eaa8efc34b88dea3234282441d110a384bfd" => :high_sierra
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
