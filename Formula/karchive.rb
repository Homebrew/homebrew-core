class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.88/karchive-5.88.0.tar.xz"
  sha256 "4b9979a3f0c1acb9822e0bea4b84e84970b9ca0a0e4daf914a35fe079f4ceae3"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5a61c9b9805072507e5193f15d0e39370b476d889a34bc9d3628ceaea9d1abfb"
    sha256 cellar: :any,                 big_sur:       "640341f71e945abad35ea9e64f3800c47b6c5b76c06a06300f415ea710c253ec"
    sha256 cellar: :any,                 catalina:      "de15c7ba052897d75f386ac6c5b89096ef831677179042bf375d396c5531bd01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "757039b15739348a506b67dae58cacb8d7a04e5438a76eec66bfac2b1d7cbaf0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
