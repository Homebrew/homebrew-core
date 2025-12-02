class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.20/ktexttemplate-6.20.0.tar.xz"
  sha256 "1515959105fced74683c91aa1bbf89338279614c1ed7b17abe954e01144f4c19"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "c871cd29488129d535fe291a4154eb90a0dc981504834ef367a6ed70d14e94a8"
    sha256 arm64_sequoia: "aae8f96932d6c6082fbcd54b5c22bba99c27d46e499e9291b143371f8f329422"
    sha256 arm64_sonoma:  "b5b11a93e1ff4bf84b419c9bab77c464edc0c394c629ffb97ddfe8f39a9b2760"
    sha256 sonoma:        "46d1935e6d006a9a845f85bec43c8e2fa3667f70cbccf90f55c693bea0e7f9e0"
    sha256 arm64_linux:   "f28c8a895bf3a973d3871068ff268703529f8f1e1f97f70be7b0ea8ba5cb6ba9"
    sha256 x86_64_linux:  "95c7ef56897e991c52812d00184bdfc0ccd0b05ed419508a71284dc37f9a772b"
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
