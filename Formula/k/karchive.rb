class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.26/karchive-6.26.0.tar.xz"
  sha256 "a7fdf6d0b8db88d60aa52bcc87d8e00d95391a1ad39a4b2a8e9f3027b8ff4035"
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
    sha256 cellar: :any,                 arm64_tahoe:   "13d4b281ae395126da255ebc83fd315922aebcff27a6db0adcb7c1b837448ca6"
    sha256 cellar: :any,                 arm64_sequoia: "2eafd1cc9a9140fe67695d2882c96b92597a666d84871730c3a65aa57b02e67b"
    sha256 cellar: :any,                 arm64_sonoma:  "1e311c9de19b1f2b929dd6f42fac3e6af7b34bed6c48ad3d9191f0696cb735a4"
    sha256 cellar: :any,                 sonoma:        "da217bb7a30993091ff9e69d2d4459fde1fd0aeac1964a0dad7d3980600aa0be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "703c7235026873606457613872616002a3545c441c953d6ca134c3cb5f075655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a999ee99911496dbae8860b4a4847f0c0f9ca084d296a891f2b70ba89768e3e6"
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
