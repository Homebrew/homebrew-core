class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.40.tar.gz"
  sha256 "8c01db76669dc58c595e2e1b9bdb6d462f3363fc569b15c460a63a63b8b6bf30"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa4c75c5fca52ffe959dad0858ad684b2be0ed1abe64ac28b35e659f006f3d57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8c1fc9c975ab8165b5640518d251349d30375a6f08d24319b9fc05cf1b5f370"
    sha256 cellar: :any_skip_relocation, monterey:       "508648c23b736ec0cef911a4094c6a9ee932eb9020661329b80016f7eaa2e353"
    sha256 cellar: :any_skip_relocation, big_sur:        "482e258a5cf522bb43a81e52aa6ddc4056e8b4d6eb78ba4f2d1ac69d40ac90e8"
    sha256 cellar: :any_skip_relocation, catalina:       "d323de7c11c4e6819791549973179ce17beff5006808b12de853d883b8b53a90"
    sha256 cellar: :any_skip_relocation, mojave:         "b7b27454dfe6f064522553830932b00d51b26fda6ab1eab61d067e7bab10bd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ecf447d33b766ceeecab97f1f5591bd8742881da9537359ac4c573593867801"
  end

  def install
    system "make"
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    (testpath/"first.bed").write <<~EOS
      chr1\t100\t200
    EOS
    (testpath/"second.bed").write <<~EOS
      chr1\t300\t400
    EOS
    output = shell_output("#{bin}/bedops --complement first.bed second.bed")
    assert_match "chr1\t200\t300", output
  end
end
