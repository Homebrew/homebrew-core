class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.3.0.tar.gz"
  sha256 "7aa04296c8c7b985906b0c550dec70822b8ff176aaf5a728a97e94673844b8e0"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "523a0ed0ebca6cca9a8fba3747ab872df946a3c8f0ccd47914d5fff390d59c5f" => :mojave
    sha256 "dfc74fc8ce50bc36dfb17a2e3bcca61046eb74fbccfe84821605637278b51262" => :high_sierra
    sha256 "269c5adacea9f4f3f900ca0e4e26ca233c7267826341507303fc26ab5baa781e" => :sierra
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
