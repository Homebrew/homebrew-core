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
    sha256 cellar: :any,                 arm64_monterey: "469dbb974bd41e689abe73fa9604dc1ceacb4a955a2c9af87fd1bc93b75883de"
    sha256 cellar: :any,                 arm64_big_sur:  "4629879ab3ca0b729e7f2916e57b378fea504a1506287d93ce2ecb2d142b689f"
    sha256 cellar: :any,                 monterey:       "853b6e34f71c637373fb800da27c41c9b9125ca3e0369b3e7101951e66c7b7de"
    sha256 cellar: :any,                 big_sur:        "cd11e2cab20c550f7aa3a176aaa87b32ee04465b8842bc632f604f434e11fac0"
    sha256 cellar: :any,                 catalina:       "4d2a237f4cdec023e072557ccdde6602304260830de49cc6a5e62aed6a996735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "775fc46d8b6006e45f38206a8017f5eed325ba3bf4d436278f67257a90dea5e6"
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
