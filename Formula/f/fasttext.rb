class Fasttext < Formula
  desc "Library for fast text representation and classification"
  homepage "https://fasttext.cc"
  url "https://github.com/facebookresearch/fastText/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "7ea4edcdb64bfc6faaaec193ef181bdc108ee62bb6a04e48b2e80b639a99e27e"
  license "MIT"
  head "https://github.com/facebookresearch/fastText.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2f34f054bcdc5336bfc1dd00166ee8a07de80c678f0466b79544544608854def"
    sha256 cellar: :any,                 arm64_sonoma:   "365036caa34f9ade5d4f9685b516fd7973c2806c04b39c4aa1c54b06006ba58f"
    sha256 cellar: :any,                 arm64_ventura:  "891397ee186031bd9cda06521af21d17f1ddad2f493353320c924bb9f60aca76"
    sha256 cellar: :any,                 arm64_monterey: "5a2a2a202ee6d5b21bc1857be97e41876353e9ef9c4a2af5466b7def501bc1ce"
    sha256 cellar: :any,                 arm64_big_sur:  "3bfb7e1ab42dde74ac0692d2016f718e173b9e9dee093e408dda8f4c22ef1a8a"
    sha256 cellar: :any,                 sonoma:         "bba37fc07309acc0ea25cec159d062707f42b509a4c41a12d34bad56ac168c92"
    sha256 cellar: :any,                 ventura:        "05f913451fccb021b6c17c9b4d7e42eee0bcb9a2840c185c3099e3c2b1acbe0e"
    sha256 cellar: :any,                 monterey:       "7b1b5a4cbb2ce1de373b18eec3b8cdaeb1e5ac144b0f191fca05b977cf54c10e"
    sha256 cellar: :any,                 big_sur:        "3869650705430f8b682416be4e7c0a01c243a2f9517c6668027c6e9576f1e9c6"
    sha256 cellar: :any,                 catalina:       "ec085551ced1f55b863a65aa60ad8f31d796002702b7effaaaafbf1490df867f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a90d77cb50372ab1172b354ee29e813f26543067beac35dd24b3da882352718"
  end

  deprecate! date: "2024-03-19", because: :repo_archived
  disable! date: "2025-03-24", because: :repo_archived

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"trainingset").write("__label__brew brew")
    system bin/"fasttext", "supervised", "-input", "trainingset", "-output", "model"
    assert_path_exists testpath/"model.bin"
  end
end
