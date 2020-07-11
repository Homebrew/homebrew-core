class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.72/karchive-5.72.0.tar.xz"
  sha256 "d1857451305bbc06c2391f1be2aa59836291910391f4f26f243e8f038a47ef5a"
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 "fcaac3ae2d0a0e3913655045d10bd67cfda22b75cb614ca5e2489f6279a0ef1e" => :catalina
    sha256 "05298d1069248c3d538d0281b671e4eb6a5d33bacc7129f94248fa7ee9b10f86" => :mojave
    sha256 "25eb5f0d49e82b034040b70ec209ce10fbf19825d4f0960795127cb5e96b3522" => :high_sierra
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
