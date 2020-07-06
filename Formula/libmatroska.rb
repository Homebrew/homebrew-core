class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.6.0.tar.xz"
  sha256 "fec89cebd500807f7fd14b56c14733f11045fa2a21398ff6f6c5c0e3e01b4033"
  license "LGPL-2.1"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    cellar :any
    sha256 "6e0fcb6eaab382b943734853dc74b58abc88d1a6b58623aed85c2d3d62676a06" => :catalina
    sha256 "d6ccd27705a5ec5b414f1373fde91ed7e4b27b1a98ddadf92ce14dd879e7f2fb" => :mojave
    sha256 "d55b378401f82f39c47af6cc4568c7ddf4d1a18534515b58927112539bd3dce2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end
