class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.92/karchive-5.92.0.tar.xz"
  sha256 "5076a28c3a10ab755454c752fa563a4be7ad890f391c43aaa2ee4ee4b6a99fae"
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
    sha256 cellar: :any,                 arm64_monterey: "a84fa580c91a7e6bdf3d7f163731472f4b1e23444cca056cecfbf910f0fcff39"
    sha256 cellar: :any,                 arm64_big_sur:  "e7a8d41cab4636789f6b577a6d09a7a0f51dc95460dad0446dc135403e0a3ed7"
    sha256 cellar: :any,                 monterey:       "8699e83569139a506ac5f429359879d4b00bb86dd81f77308a2a56e1702abb73"
    sha256 cellar: :any,                 big_sur:        "4961d878108ab7e7bc8f5d1240a88fc9bdd4ac169230e70ccecd24596f6893f6"
    sha256 cellar: :any,                 catalina:       "54a264357a6053a03ad0c46e725183c393124c7c79649785fb3ba77342e82bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80dcc6a394c3258ddb52a216822f04afa541b67218ce105c5b96702edcaa8856"
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

  on_linux do
    depends_on "gcc"
  end

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
