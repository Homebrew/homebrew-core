class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.100/karchive-5.100.0.tar.xz"
  sha256 "f5ae507b0ceca71229017128997e12eff51b697ca2a1a37b729f9253ebfe969b"
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
    sha256 cellar: :any,                 arm64_ventura:  "ae4310b1ff5d959da79c2b4434f6c5aa9c958222532909033282d26433c530aa"
    sha256 cellar: :any,                 arm64_monterey: "eda67ff177a5986f63ca07f104e9df9bd6a216dbe29843fd38c84d69b21329a9"
    sha256 cellar: :any,                 arm64_big_sur:  "a9e06742ae33e5e299f0e83fa3394c5102b5d830e8894562373c3c311c25f61c"
    sha256 cellar: :any,                 ventura:        "d787876a78611ecdd88e860936060e6ee5eb1f90ccd6e6e6e4b7618911b9f28c"
    sha256 cellar: :any,                 monterey:       "c75474f1d218b7e11afbba0457b341dce4747c4ced36debdb7da735b06631365"
    sha256 cellar: :any,                 big_sur:        "908427b570afe6bd73de2091c77a8dab21576ccf4889d83f4d7a8ebdb7c8a1bd"
    sha256 cellar: :any,                 catalina:       "58f14148cafc6a279b68ce789b35f092474c5569642a1cca066e6b91783be59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a8b0b035fd795dbd016832b2c84b429541d6cf48ee02aa925be1aeba12cade"
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
