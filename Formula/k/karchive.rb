class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.20/karchive-6.20.0.tar.xz"
  sha256 "f6a508d537d283e2a106e848a939e971cdf1a059779825e4482609aa981ffadd"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a440e61dbf44ad247e66703cc7c8f5bb3f4133aee6b96402893664b5810406e9"
    sha256 cellar: :any,                 arm64_sequoia: "03472146076df7741d7b61f32e4f8ee7551a866b6af47c595a0a946e5f23dc14"
    sha256 cellar: :any,                 arm64_sonoma:  "5b0d63b31b1414f7992948ee5daad7b21ad7fb4bcafa40c8a7a6975813e93ad6"
    sha256 cellar: :any,                 sonoma:        "26a9bfc85852a06c0140d1e54a3f941a8e07357effc771bc092b220b30d8962b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d53412b6073a25f06500082cd5f3dc829c225ddbf72f27cadc8e26524f82ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb5096770563c0db1703fea66f2184fb23a0ec1b714b57945ea101daa0f4bd1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "openssl@3"
  depends_on "qtbase"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples").children, testpath

    examples = %w[
      bzip2gzip
      helloworld
      tarlocalfiles
      unzipper
    ]

    examples.each do |example|
      inreplace testpath/example/"CMakeLists.txt", /^project\(/, <<~CMAKE
        cmake_minimum_required(VERSION 4.0)
        \\0
      CMAKE

      system "cmake", "-S", example, "-B", example, *std_cmake_args
      system "cmake", "--build", example
    end

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_path_exists testpath/"hello.zip"

    system "unzipper/unzipper", "hello.zip"
    assert_path_exists testpath/"world"

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_path_exists testpath/"myFiles.tar.gz"
  end
end
