class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.6.tar.gz"
  version "0.29.0.gfm.6"
  sha256 "b17d86164c0822b5db3818780b44cb130ff30e9c6ec6a64f199b6d142684dba0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "425e781e4c130b392981dcc7d8a76f195bdd470200129bc9533d99279e4ed976"
    sha256 cellar: :any,                 arm64_monterey: "12f770cb258f15d387b9d5aceae76a8a5f522e7a2f4d890216e8e1acb60a89dd"
    sha256 cellar: :any,                 arm64_big_sur:  "39d8ef73d295484a155cba0ab7377e15345ee5db0cccb17e66e51cbdaf3d478b"
    sha256 cellar: :any,                 ventura:        "9bc6047a13bfdf6be957c5633518073f44801be9934244efbb0ce6dcfeed5b2e"
    sha256 cellar: :any,                 monterey:       "50c4ba44095b7d469ac4d80d65c6bb48e102fd464fa9b6dfdffd731997790468"
    sha256 cellar: :any,                 big_sur:        "b71dfdc2ccea9de10faa13a81842a545f9731f25a9bb4a7b514abfbda996b441"
    sha256 cellar: :any,                 catalina:       "344608ef10f9d5666ce379e83ae4a8d7aee632b49a99219e868b469a7096ec01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5371a79b5545784be37bc2677d5d29abdad5df126d30a4f5942a13467cf5fae5"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
