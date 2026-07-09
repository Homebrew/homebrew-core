class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.27/karchive-6.27.0.tar.xz"
  sha256 "434edf78df8f4c9f25000d107ad1520d7ac14db580a202047bf19cbf77376522"
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
    sha256 cellar: :any, arm64_tahoe:   "4c6b6665c31a4e569b5d283c61a071a0b24c739c633063bff5dd7b220c030a22"
    sha256 cellar: :any, arm64_sequoia: "2acb4c3d029eaca42e9411b510b71e37ea44cec5750245c834ab6db0dcbc689f"
    sha256 cellar: :any, arm64_sonoma:  "b384884f33be6e8a44cd69acc663780c59a524ffa96f32193fbbb02714c405d9"
    sha256 cellar: :any, sonoma:        "46095b349244fac6d05f235f44544d531cf223d973bac59c00a2c35038474008"
    sha256 cellar: :any, arm64_linux:   "67c55a0fbd318a4eb8a1d0a3d6ab78f912c98b40810112dba822b07c88081be2"
    sha256 cellar: :any, x86_64_linux:  "a65660e6022c7c9fcaaef4e2b6a8a9ef8a344aba6cb40244670c3dd25a359f9c"
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
