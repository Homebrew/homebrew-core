class Fasttext < Formula
  desc "Library for fast text representation and classification"
  homepage "https://fasttext.cc"
  url "https://github.com/facebookresearch/fastText/archive/v0.9.2.tar.gz"
  sha256 "7ea4edcdb64bfc6faaaec193ef181bdc108ee62bb6a04e48b2e80b639a99e27e"
  license "MIT"
  head "https://github.com/facebookresearch/fastText.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5a2a2a202ee6d5b21bc1857be97e41876353e9ef9c4a2af5466b7def501bc1ce"
    sha256 cellar: :any,                 arm64_big_sur:  "3bfb7e1ab42dde74ac0692d2016f718e173b9e9dee093e408dda8f4c22ef1a8a"
    sha256 cellar: :any,                 monterey:       "7b1b5a4cbb2ce1de373b18eec3b8cdaeb1e5ac144b0f191fca05b977cf54c10e"
    sha256 cellar: :any,                 big_sur:        "3869650705430f8b682416be4e7c0a01c243a2f9517c6668027c6e9576f1e9c6"
    sha256 cellar: :any,                 catalina:       "ec085551ced1f55b863a65aa60ad8f31d796002702b7effaaaafbf1490df867f"
    sha256 cellar: :any,                 mojave:         "79f08167fb55b478829434be84d919c08c888563e0abbdeb66bc19cd3e82457f"
    sha256 cellar: :any,                 high_sierra:    "4602a32c2a373ed97de8fd36bf1e998299682d45e465af39026a32a3a06fe574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a90d77cb50372ab1172b354ee29e813f26543067beac35dd24b3da882352718"
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
