class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.86/karchive-5.86.0.tar.xz"
  sha256 "13bfb0a07171bab829c3cb6760d60817608ba95802a4dfe0327cb2afb4616e9d"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "278dcdc717598e431453570c460e4dd426373ce601da9a055dd74803e3e7e04c"
    sha256 cellar: :any,                 big_sur:       "1aa3145cd267ebfde21947f35efc3753db291ac31ca305b197d44914c20b5a2f"
    sha256 cellar: :any,                 catalina:      "c065d767664500cdb9917ecb2928ac050d2b23c9c170bf318e6008b03e867c28"
    sha256 cellar: :any,                 mojave:        "f5788fef0d4a1f50f698e6818244ed2f2ae81b2f76c288e81d9e06fb41606940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac5a27cbfeaa909cdd7b6864d441528fb34172ade5d8371de0fc008915710d3"
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
