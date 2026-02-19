class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.23/karchive-6.23.0.tar.xz"
  sha256 "80f7f3c32a9ec072a650985fca66b20eb8f19a7b10fca44a9d7ad8d8a8645b50"
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
    sha256 cellar: :any,                 arm64_tahoe:   "99bb49bc54ce4769200095ab3993975bceba26059b9f1426b5f4e45fb7a5bbc6"
    sha256 cellar: :any,                 arm64_sequoia: "310fb1928e680354c9dfb5a672402215451d1bc9aa0761e6962a150a42f6d7ef"
    sha256 cellar: :any,                 arm64_sonoma:  "2105a4a0f90afa5b3e58c9a780739deb38710319ae508ca89ecc994730fc8e0b"
    sha256 cellar: :any,                 sonoma:        "dde1551a70490ba3703b655efbe410d34125adbfbf243a3cb22b555af2de2cb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa8ffc6b1123bf688ff5a17bfeccca5faaee4ffca32641251a69fc02289c7533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3acef557ea9741b0467fb428779ef5d3c63c33964b44e6a47b5315bd525a2243"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
