class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.28/ktexttemplate-6.28.0.tar.xz"
  sha256 "a184163f7d5d2ac4cd4a71d04bee830020332552bfa9eb5159ced57b20edd527"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "bb37b940a594f51acc0f30b65036810aa439c4fe9aa9cb956577c69c93f3aad2"
    sha256 arm64_sequoia: "4eca6901d58726198c1f6e6ba82102b597e57016082fd2e44c7e24dc21dfc338"
    sha256 arm64_sonoma:  "b41da47a336f51aca85293b2ade3c4ffdedadc044b6c085d94e608ba40658da1"
    sha256 sonoma:        "2b279f012d49eeb4b4998c9b585a678dbe40461e8915be7d3c5e2758ac2bcc3c"
    sha256 arm64_linux:   "15927e729a7544ab33cbdc2d47aafcf85378d68502126ac36e7b1fa253912e3a"
    sha256 x86_64_linux:  "3fa26d04e52130353349ac693a94b9aa5b9513d7cf127cc5bd88e42c56294be7"
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
