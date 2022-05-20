class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.0.tar.gz"
  sha256 "f723b7f8d6263bee4048e73fd2010b4275550b9a2ca2eeca16602c1d6fb3ac49"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2178cf5b5b7bbbb644782801e4b0eaddde8696eb73960207dc9e0b3e38a93ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37813fdcde5b0ba9b963d81d7cc7a2af2b15b9105fee3f68ca5ee812ce092185"
    sha256 cellar: :any_skip_relocation, monterey:       "651b524b911174db34914396bf37438d4cce7c59ccf4faabafa91bbd1afe36ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "8df002d1325303f60e7ba736ff09d941d460999f842da0c6d85b8b59459ed7d3"
    sha256 cellar: :any_skip_relocation, catalina:       "f6966021699830054d8f3afc31cc2096728e25729bf85c364916651eed55f191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0107d103636fa32446e7da80a5396f902921a32b6bfa518c27c1fc65a909c2e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
