class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.110/karchive-5.110.0.tar.xz"
  sha256 "fcc6583c0be5abbb9744bfad8d3e673a5b0907bd0787f7da338cc3d989040cdf"
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
    sha256 cellar: :any,                 arm64_sonoma:   "73afed52588a6a09f660cf91c16a997d95612cac17c68024832df1ff3d3e5629"
    sha256 cellar: :any,                 arm64_ventura:  "c8cfd4326c06208eef3a1fcf314db99efa1de1f7faac8227d3afc99751d7a346"
    sha256 cellar: :any,                 arm64_monterey: "6115f3ad581f95853da6768f5a75a9d68bad7dbed60ee7c0fe81b5f71a57c78a"
    sha256 cellar: :any,                 arm64_big_sur:  "004c3982a135d76df4bb0481ede4be044b91f8dde40870ab09f15d4caed780b7"
    sha256 cellar: :any,                 sonoma:         "d9db9d5520a13ff04fc4fb2d693a71ddff9d7cab11b42dbc79233395a452e67f"
    sha256 cellar: :any,                 ventura:        "60a2dce9780e90b780fa42ad92408473130de62f0096b68c3ecbb8d1a396842a"
    sha256 cellar: :any,                 monterey:       "134d4824e80776d5779ebd23678b2187d36b43c15d1e8b370b9a51b8002a0b90"
    sha256 cellar: :any,                 big_sur:        "71564a2eb2b19df30a276cd19a050420c9d85b6835444f8f8d2ecfe6f9097715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0b9b877886e30fc936b60c94c3a6fe5f93228c22353bbb868ef17311af54baf"
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
