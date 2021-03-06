class MuntMt32emu < Formula
  desc "Roland MT-32 emulator library"
  homepage "https://munt.sourceforge.io"
  url "https://github.com/munt/munt/archive/libmt32emu_2_4_0.tar.gz"
  sha256 "3a53a5ad59e7c92de10e81b9c50d00e5e249aa66e6d2d928d042392db963f2b9"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build

  def install
    cd "mt32emu" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end
end
