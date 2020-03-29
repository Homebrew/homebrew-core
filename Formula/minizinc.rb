class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.4.3.tar.gz"
  sha256 "c5c379b0275cc6c0fefd4568e621a43b6f1f0b4af793fea5995be7c6cf73cc07"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac8a3708d18b387b114d96c11c689c0578e3d0119d6d86c491675759e6e7d4f7" => :catalina
    sha256 "c08c60f5bb8d063262f6c787ab7c5ad7a44d2f42aa0be2b783f20d4f6effac11" => :mojave
    sha256 "41f9a16e2ced9b258ff971a301b03a03a09b691f04917478a79239cdacb6b706" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :arch => :x86_64

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", share/"minizinc/std/all_different.mzn"
  end
end
