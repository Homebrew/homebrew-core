class Fasttext < Formula
  desc "Library for fast text representation and classification"
  homepage "https://fasttext.cc"
  url "https://github.com/facebookresearch/fastText/archive/v0.2.0.tar.gz"
  sha256 "71d24ffec9fcc4364554ecac2b3308d834178c903d16d090aa6be9ea6b8e480c"
  head "https://github.com/facebookresearch/fastText.git"

  bottle do
    cellar :any
    sha256 "ebe964b6cd19c3a6c742e77ca7c3ceee7bf7d5bd509d8fc6e57d2ed90a345771" => :mojave
    sha256 "ff2e7e838e290b4f18140cb60e0420561938229bf393ac6b1e6572560e31cb7e" => :high_sierra
    sha256 "a2c9b33eec2908d205e13c13dd68dea64ada417d41984080e9bd74e949f53985" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"trainingset").write("__label__brew brew")
    system "#{bin}/fasttext", "supervised", "-input", "trainingset", "-output", "model"
    assert_predicate testpath/"model.bin", :exist?
  end
end
