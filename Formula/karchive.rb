class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.97/karchive-5.97.0.tar.xz"
  sha256 "1bff8249ddbb5a38916c9e145e5027de3f18a14772e7a8bdd4a954fae7ca8d92"
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
    sha256 cellar: :any,                 arm64_monterey: "b8ea0d068ccb226233cfba1cddbde1fbb0094812bf9fba5baf8e089776da4072"
    sha256 cellar: :any,                 arm64_big_sur:  "482a553a7e8928dc62d6ab13204139349ccaceb1916351396abae67bfadcf77f"
    sha256 cellar: :any,                 monterey:       "0b1a5d0e5df84fd9fac3967a1d302c936ddc947193887cff012e40ef5190540b"
    sha256 cellar: :any,                 big_sur:        "f8fbcf8d3a8dcc008eee5349395a8847b4a6c2a345d88d38b4b03351179d7159"
    sha256 cellar: :any,                 catalina:       "e62a95e48c84b902c781ebcea4a50486138fd10b9b4da6e7bf0ce91235e874b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8175110177ddecdccde56888bfb35e2292494782f784141f4441a9365c9c83dd"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args + %W[
      -DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core
      -DQT_MAJOR_VERSION=5
    ]
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "cmake", "--build", "."
      end
    end

    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end
