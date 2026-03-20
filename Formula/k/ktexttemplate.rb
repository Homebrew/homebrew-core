class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.24/ktexttemplate-6.24.0.tar.xz"
  sha256 "85021f69f61d09fe5b1b01075dff4fc90b4d3598f7e83bdd4fee31d4a01488e0"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "8f3a2420924cc7307c585fd3cde62a3091af1b4629ad5936b7a55fc0c46bc1d2"
    sha256 arm64_sequoia: "2eb124c0b6752ef08b7e113d9e772d75568f8adb4e5725204290e671d5de6321"
    sha256 arm64_sonoma:  "e9dfc32f3185953b2ad774ef8275c4d3a63c96c569cb10fa6a73d42d0b71360d"
    sha256 sonoma:        "d54239960abe6c7bd014e527d0bf418f2dcbe29fa769956a6af883e94b1877b8"
    sha256 arm64_linux:   "ed9838d4d95b4fd7509f848de06f44890fc2a1e62eab63909b3325c0305763b0"
    sha256 x86_64_linux:  "1dacfb46ef06d35f682e0b52b1fdc7b6ddb6e8c2a3c4b46ec8b46d98bc5b7b09"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qttools" => :build
  depends_on "qtbase"
  depends_on "qtdeclarative"

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
