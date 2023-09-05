class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.4.tar.xz"
  sha256 "82dc5f83356cc9340aee76ed7512210b3a4edf5f346bc9c2c7044f55052687a7"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libebml.git", branch: "master"

  livecheck do
    url "https://dl.matroska.org/downloads/libebml/"
    regex(/href=.*?libebml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6eb9f540875dd00954c2f7cc05b364afc758da99575624c62a0ca14e0895502e"
    sha256 cellar: :any,                 arm64_monterey: "ba75f1f3e72ba8c13b03cef0a7114c67449fd357498dec0c8f56b8ac4ba00454"
    sha256 cellar: :any,                 arm64_big_sur:  "67fc822f0ce6ebc4d2bc2026b49d0041f10d19d566b550f53c60ca271b498897"
    sha256 cellar: :any,                 ventura:        "e985e2c3dc576f7c170f2f874287d71a8b89d13303418eedfe72da0755300a0e"
    sha256 cellar: :any,                 monterey:       "ef6c2a1b92f0cc3fda10e64b64b752be40a5203414a64679f88f2ebcf8cbd2d4"
    sha256 cellar: :any,                 big_sur:        "14f622d3b763047022267439e48533de2e823dce152d2db89533efe2e97b323b"
    sha256 cellar: :any,                 catalina:       "16ebc1c2cffe2e77dfc1b4f9f23553b6e9e587ef581e383f5963844e9003dccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbb6281e4491af83eff56d89c3fccff6dbf6662ce61099f96e2d2f09c99dee46"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
