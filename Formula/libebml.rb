class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.3.tar.xz"
  sha256 "746abbc216b634ec17e70213b9a2ae2aeef0ac1ffc393f2f96f7e4cd5435a921"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libebml.git", branch: "master"

  livecheck do
    url "https://dl.matroska.org/downloads/libebml/"
    regex(/href=.*?libebml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "d3af7501c3d4eef59d70cbe6d0db0dabcf643f060b7167e90f5f84e598611831"
    sha256 cellar: :any,                 arm64_big_sur:  "f2b112005f974dbbc725949ba9c66cbca0dbb101934eaccfb15999d0694e2a0c"
    sha256 cellar: :any,                 monterey:       "5d981e2ec0b97d3d1fdeb73a905239ffa8d031c27f0b55b0a57436705afa9999"
    sha256 cellar: :any,                 big_sur:        "1cb134879583bcf749d5dbe0cb0fc0743b4323e224be904dc5865dd42e96e774"
    sha256 cellar: :any,                 catalina:       "6eed9db58a9132676dc1c2ff0877f48a6424afb465c9654887956cd845cee2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e0784e6765ab397b2f121fb032e9f3a8dedf7e2745570126d377e88a384304b"
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
