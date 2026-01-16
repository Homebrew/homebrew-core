class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.22/karchive-6.22.0.tar.xz"
  sha256 "84254bd0a51ff3d5e2fa22bb946309cec508f1fae726a7aea15149260c4db59d"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ee3e9c78507d928cc1eb5ea839ddcea3de2fefffbd7aa7fefb3e25cc7a771f77"
    sha256 cellar: :any,                 arm64_sequoia: "d5ab425c82a046c3934c2b9aeca5465a98043ea4354d97e3c6fbead0ba80922a"
    sha256 cellar: :any,                 arm64_sonoma:  "3cb41476baa0959b0626939ee2f081a55e87f51c0abcdeee96c9cd8ea7308366"
    sha256 cellar: :any,                 sonoma:        "7ee279b10eee9d8ffa22d09eccdfcea3251f2a46090c3771b4e787a419cbfc59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "335e24c9c13826e14fc91fca58c8a0432b72c5064e294263fc878e3a1c760d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e17d609369b736aabf074a7c154c4669dd2b39b0186da23f89414460f5cfc5a"
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
