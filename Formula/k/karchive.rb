class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.0/karchive-6.0.0.tar.xz"
  sha256 "75a591d9648026eb86826974e6f3882e7f620592ecef8fabeb19206e63b04e50"
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
    sha256 cellar: :any,                 arm64_sonoma:   "92f06d2e0eca0029ff322620ed385e83f6091c4ba0e5ca2e4f5b470b4de3f06d"
    sha256 cellar: :any,                 arm64_ventura:  "0493614849c62acff76da55d8d498d2942bdf66178da612a4fc74336452f73fb"
    sha256 cellar: :any,                 arm64_monterey: "5838d0d84de36e069abb410008c146cf5008299ffd20fee2655b667a10ec99ff"
    sha256 cellar: :any,                 sonoma:         "1341eac9a53a73d69aed262e1817cc66187e07886f8cbaf0ed7de8a24e8acbca"
    sha256 cellar: :any,                 ventura:        "895d6a133515aa58d5aafb7e29287c6bd427475ede0eb0148936d43692d1cae1"
    sha256 cellar: :any,                 monterey:       "7d043dd9436be82a39a2a53274f1e464223df5c9f1095c00039069bec8a3f5fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3027ed536eebbd565269ea916280c3712f11dcd42ff29972049631c77b363cb"
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
