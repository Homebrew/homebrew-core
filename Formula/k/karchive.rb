class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.10/karchive-6.10.0.tar.xz"
  sha256 "ac5160c19dd110bbdadeba9c5355cbfd3b5c1bd00ce3dbdc4a085776698c8a48"
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
    sha256 cellar: :any,                 arm64_sonoma:  "cf9010a947aeebdd4755b9f60baaeefcdef0b17023e74be3f8fac01d49abcb1f"
    sha256 cellar: :any,                 arm64_ventura: "a36d71b78cec67ed38e4f24d4727f2f40b5f1607a145c215f391337f58b2a2c8"
    sha256 cellar: :any,                 sonoma:        "3e7239bb794e15e2dac11cfd1d745a5b61f9f1547cba5dc0e81dcfae2689c0ef"
    sha256 cellar: :any,                 ventura:       "bcf3924c71923c865fbcffe075726885b983c56430e05680c15639ead7cf9512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e37808acc0481eb324c2248a7631cc39e8800b80346e521d2d45460709b019a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "qt"
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
        cmake_minimum_required(VERSION 3.5)
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
