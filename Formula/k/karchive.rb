class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.24/karchive-6.24.0.tar.xz"
  sha256 "b68faa1c9012e40bbed516d8bb6be21e743af5aafb0249a84c29a7d9ff150d0d"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a24aa14f36fcd4b4cc8f1c34727d23549e192f3933e7248ec125d019270dee40"
    sha256 cellar: :any,                 arm64_sequoia: "ea8249cc68968bd42e9298403301f575a2fe3acdae4acbf1ffeced3a68fa8338"
    sha256 cellar: :any,                 arm64_sonoma:  "7d406662e4aa393991ae8729cb87d22d1d307599842c43495c76a3ecf83c8226"
    sha256 cellar: :any,                 sonoma:        "6bd598b97894c6507a9df94e3721ba7fe3bc91ed4b70abd6c7926af6610bb480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a213fbd1a3f0c2192b9c0575f83454dbc9036827c25c6c5cf9c23bb010f13db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0edb8346a26e992723f0d2e94dd54a62b0b80d0c60921c0ad80724ccc8b65918"
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
