class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.27/ktexttemplate-6.27.0.tar.xz"
  sha256 "18a92b802b1c3130ff22087f9e048807bdf39c4147835e9aaa1be18408b9361b"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "c3e5c277ee2ede524f4cffd3a2e8bdce36107ab4186a98396728b0b1f4a69747"
    sha256 arm64_sequoia: "6432ae4a1be746623c88dbcc75282125cd42f93b9aca8be825eb9322300c4b9c"
    sha256 arm64_sonoma:  "00cbfaf4e2cf40210991a55ff0674642d1eec723c35c16ad73df10737d17bf81"
    sha256 sonoma:        "c6f5a82187e27f42e2e1e39d14ae0f640593554edbdf7dd99404dc24bd792e05"
    sha256 arm64_linux:   "1b1bb6486b10769950cf8bc33c66339a2d3651b003535c78876539a903fe8d62"
    sha256 x86_64_linux:  "e444b062564e93e0080164a1602f4587b3140cf396f941a585dbc1511eacb51d"
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
