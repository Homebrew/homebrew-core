class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/frameworks/ktexttemplate/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.12/ktexttemplate-6.12.0.tar.xz"
  sha256 "9fffd7f6c9309b2fca397cfedbdb55ded33e4a8e5438e0dcebf33b6f9500699c"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "fa61ab0cc0c21b1c9cc86aa8d9edad9f8d9f21e6ec655257b40e1cf1551b42e7"
    sha256 arm64_ventura: "be6ce5eb8d8674c326a0a4c35614f7d4218c79f352239aa5c6f9f95ba43684c0"
    sha256 sonoma:        "985c2577c07d63b916e082ac2f5554ab6283434aa2534b9dc2236e3c674a98a5"
    sha256 ventura:       "2d523e4b52eb85808b436e614f02ae4da6a1589d6ecd109b9587a4d9abdc498a"
    sha256 x86_64_linux:  "1a63a9cf3e5ea0f1dcbc6dbd4594c6ca046a5b2e5611f3d6a8f4cf27ddfaa93a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qt"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system "cmake", pkgshare/"examples/codegen", *std_cmake_args
    system "cmake", "--build", "."
  end
end
