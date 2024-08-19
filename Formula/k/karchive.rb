class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.5/karchive-6.5.0.tar.xz"
  sha256 "e5530253c70de024926e1985154f9115f02af50c7d998a874a3175b404444e79"
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
    sha256 cellar: :any,                 arm64_sonoma:   "e41b52cbfe087d0cc9d8f10d6bd4a2efb1108d86edf374471b89ec4c75e671da"
    sha256 cellar: :any,                 arm64_ventura:  "9085c3eeb0d055dcba1719f068d78d7f9396395a054e6b2b35df1eca375431a5"
    sha256 cellar: :any,                 arm64_monterey: "1cd3f4c0b204bb7f35dd1212447a6768293b2017d9abc31d1a92fa89e543d9d5"
    sha256 cellar: :any,                 sonoma:         "78fb50b40afb40cbf1504bac628c9745bfecb46b08f308c3ba34832c93e6e87b"
    sha256 cellar: :any,                 ventura:        "d41bf8b26d4754afccd6673cf967863e883cb22f09000c9921a82bd0ee1daa3d"
    sha256 cellar: :any,                 monterey:       "c121d123266e25ef9ccc7e8728390d6bcf28d0d6eaeb8848686ff4d3291d652f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d88f8aa91a4803743c9ab152162f797c35729c354a9aa92a1c3b2353e8c4d0f0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

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
      inreplace testpath/example/"CMakeLists.txt", /^project\(/, <<~EOS
        cmake_minimum_required(VERSION 3.5)
        \\0
      EOS

      system "cmake", "-S", example, "-B", example, *std_cmake_args
      system "cmake", "--build", example
    end

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end
