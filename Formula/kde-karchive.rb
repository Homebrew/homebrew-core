class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.78/karchive-5.78.0.tar.xz"
  sha256 "82e7a24280132b1654dc36caba52676b988a9feeaa6dbb9d398b170608f012d3"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 "0f3f24905080f98c8faafd655f7e467502f2bfb1e1995c96cdfc41655c226cd3" => :big_sur
    sha256 "e2787c4c672f43c4368d74afec51e366034c28e91507a2ddec5c04115bba1c98" => :arm64_big_sur
    sha256 "2c1e9221fe22684b6eb017cc21db665990ad3211dff723e46033404fc8be1929" => :catalina
    sha256 "05508d1c0d1733b8bdc57394269c6b09e899d56850b2fe68a27e7aba261f9fa6" => :mojave
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
