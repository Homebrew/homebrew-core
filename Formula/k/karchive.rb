class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.13/karchive-6.13.0.tar.xz"
  sha256 "3c9b5dcf3abdfe2761e2153d70d9d667f1ff0fd2f6c80addba7549da954fcc90"
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
    sha256 cellar: :any,                 arm64_sonoma:  "3b748c031f3b2bc94dca70bb3c8737b4c3307e5f557cc6b32753450f5b69f975"
    sha256 cellar: :any,                 arm64_ventura: "b5085b9a6cd57d98c18dadd7357f6f1cd2e61609dd4e760788dad53c091e81b4"
    sha256 cellar: :any,                 sonoma:        "5e1bd739ed5c7a4fcc3d4a74e0274712dac8f921d16a85e3f81197f607656a3d"
    sha256 cellar: :any,                 ventura:       "80c34464afd5b140e5d2e8b7be722294c648dd9418476a79f0987f1e11c058f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2a9928a587360ec5414ada4d9fd7a1ca345c481ebbec2bb62e11a7a8d2fe6ef"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
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
