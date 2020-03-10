class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.4.3.tar.gz"
  sha256 "c5c379b0275cc6c0fefd4568e621a43b6f1f0b4af793fea5995be7c6cf73cc07"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdcacd5a4ca033867a061448461bc5a740c9f860e6adb16a6b9baa5c1a2f360c" => :catalina
    sha256 "4f879b71bc2a436e141b0391a95c9b59ad0f8b6547e3c22d54095af820cb9c01" => :mojave
    sha256 "2d5e0d69ea0d4622e665a80a2dfa76e8b01903d22bdce2362c6b58eea023c4b3" => :high_sierra
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
