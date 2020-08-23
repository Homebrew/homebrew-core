class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.73/karchive-5.73.0.tar.xz"
  sha256 "25481ebbba8f58d9ab45bde804ab0d873c45550b482e27e7856b362cd9aa434f"
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 "5d5993edc094152be0659cf0c8f6bec828aa8f0ceb187644958bd80936af3c67" => :catalina
    sha256 "cd68910063856432b3f983a0d9ee7eb8faff9d0328221dded1c89daef11d8bdb" => :mojave
    sha256 "79f0a91cc9dcaf24a033b23c4b46269244a4f4642ec6c68756e29b735aa9e2aa" => :high_sierra
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
