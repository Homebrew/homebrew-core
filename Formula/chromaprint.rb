class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.3/chromaprint-1.4.3.tar.gz"
  sha256 "ea18608b76fb88e0203b7d3e1833fb125ce9bb61efe22c6e169a50c52c457f82"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d4c053d1d43c82acf084d864745a6564687b246623b2d5c421822f1941691280" => :high_sierra
    sha256 "76cd7d5f0b2b43bb17f81666329521db69f58724022a3dc5e3e141fe0395a196" => :sierra
    sha256 "ff534ae7e7c8a86bee2d107f0393f7db5e6f4a1504274e03c1ec346b446bfd28" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
