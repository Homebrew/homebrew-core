class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.23/ktexttemplate-6.23.0.tar.xz"
  sha256 "0623ad7fbf7b3aa22e0f76611c2e9c8fa2761cc29fdcb1548bce760cd328d490"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "5e7c2aa5252254da4d94af44fce70f617902c67b38f5634ecc13b534752d091b"
    sha256 arm64_sequoia: "f3ef209d63872d8c72f3e3b74971d301c427798b1518e68508e25189eb93d174"
    sha256 arm64_sonoma:  "819fcf5abe12dbd4037ee1fad001ab3ede42b285b7b5b9e825a4aca20061d1ad"
    sha256 sonoma:        "32ebaee7e36ccf230c693a8866723afc95ba47f9b62e18f0aa0a567066f68c59"
    sha256 arm64_linux:   "4a3d3f0d54a6e7038a4218275e8709b0081ca787ed872ab6152b40267b746245"
    sha256 x86_64_linux:  "c7b2cd2098d1ccf732b54928743865dc8324d82afaf8f9aca37d430ba436d21f"
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
