class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.25/karchive-6.25.0.tar.xz"
  sha256 "123a268352ab63d548ba5e3c3e8fbf1d737025e4c5189821cf10e3328ab4de15"
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
    sha256 cellar: :any,                 arm64_tahoe:   "19e6ce959e6f93dda1de68d2b47b7f2f6f934130b3b6fc6d22e2f3364406c6a3"
    sha256 cellar: :any,                 arm64_sequoia: "77cf0ddf1904c4431e89cd4844aca070ac5b9ddd9000dc15eacd1089124b2b36"
    sha256 cellar: :any,                 arm64_sonoma:  "11e59d12ac3d07eca6e87b9ce54417060609ece7049f93012188fb1ecd02406f"
    sha256 cellar: :any,                 sonoma:        "0fd6458709bbe9d18fb2657ab74b093cac214e67f504a7022febd96dc9cd5d80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69551f4098a2ec0d599092ed38dc5ab3af1e6251e25f4028d16433cd0320eccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec60c2e776246fd36fb587c7162fd365c30e4f299a839e60938ee546e17c263"
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
