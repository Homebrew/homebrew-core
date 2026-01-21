class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.22/ktexttemplate-6.22.0.tar.xz"
  sha256 "53038e8eedb91e0672bd52bd75b89d196821db3b9d30a0a802f4c964e68f1f7d"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "431f74be8f93e2fa064bbc9abf518ae47b601ad161048c88433a8ca7f286b8fd"
    sha256 arm64_sequoia: "be262be047d5dbb9233ed725a96337939935e4facd8a4d78dee467bbb3ccada7"
    sha256 arm64_sonoma:  "ef8fc89ecda259ab5bf3e97b24d6bfe7c721c43d411d4d1ef2de6730584b6e30"
    sha256 sonoma:        "348c52e0ad9b90d555180cad95e58650d18b9980fa0bdcad8eb2285814f48a31"
    sha256 arm64_linux:   "bb13612529ab33e142893ab6affddf68e23235fcb06be4a0855d8cfb34cbdeb6"
    sha256 x86_64_linux:  "5b6bc39cb311eab46799bce89981af8f503cf6cfef7259f6af65e029e5c329fb"
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
