class Fasttext < Formula
  desc "Library for fast text representation and classification"
  homepage "https://fasttext.cc"
  url "https://github.com/facebookresearch/fastText/archive/v0.9.1.tar.gz"
  sha256 "254ace2fc8dc3bea0fc6ad4897a221eb85c1e9adfa61d130b43398193ca1f061"
  head "https://github.com/facebookresearch/fastText.git"

  bottle do
    cellar :any
    sha256 "be7691124ef573afe2d8cc9ba5cf76fae50a99974bf128bfd4873c272db9a57a" => :catalina
    sha256 "a4b6d2be804597582fcc3f0be630bdd8c791e2c1d530880e98f54251decac960" => :mojave
    sha256 "638910cb1f3a73c6cb9ca9ecab9b790e8f2254965ee86eeddc5dd79ee4bd3001" => :high_sierra
    sha256 "c1775db7dd27a8fac380bcd4944eda4ec1e162b92a9329ff48debf76c3834426" => :sierra
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
