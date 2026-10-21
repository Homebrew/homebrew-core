class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.31/ktexttemplate-6.31.0.tar.xz"
  sha256 "461c0d1672430f646d98d89ec226912f7ace031fda020a209b9ce270fd146c0c"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "1efd8a37a3a19079628479d64184b475e7e453d5915ada0d61b7a7e8a9a540e5"
    sha256 arm64_tahoe:       "bbb76b5be86749e81224fcc49c940e7a847b7d4391d4d76e2e5f1e758e9f334e"
    sha256 arm64_sequoia:     "d4d065835b138c6ac05f43fd4ea639789b3c91c6b178555d259aa796cc3208a2"
    sha256 arm64_linux:       "eec543b2ad9b1f1bdb742eb249d8b8a3a380a0f2d2788878fcb68d0a8b16d98a"
    sha256 x86_64_linux:      "2e2feec0895b50c7086ffed558df3639a90b2113a5ee3afea9752f7e128d581c"
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
