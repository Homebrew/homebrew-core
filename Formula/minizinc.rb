class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.3.0.tar.gz"
  sha256 "7aa04296c8c7b985906b0c550dec70822b8ff176aaf5a728a97e94673844b8e0"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "86d09e68602fcbd073c625408afbbfd8daffb25a7f255c5578eec35cf2dfa86a" => :mojave
    sha256 "18b611e96ce5dbb0258d5a5f94aa2d82c5765a4cf0ade419c7c56c1f1a8d39fa" => :high_sierra
    sha256 "088a5168693645eb6e72c5f7644af28d58c00386cfe2d0aed8c675924d14fcfb" => :sierra
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
