class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.2/chromaprint-1.4.2.tar.gz"
  sha256 "989609a7e841dd75b34ee793bd1d049ce99a8f0d444b3cea39d57c3e5d26b4d4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "76cd7d5f0b2b43bb17f81666329521db69f58724022a3dc5e3e141fe0395a196" => :sierra
    sha256 "ff534ae7e7c8a86bee2d107f0393f7db5e6f4a1504274e03c1ec346b446bfd28" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
