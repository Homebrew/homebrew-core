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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093e34aaa18a6000971319cd6686e614c520ad5db4632be788d3ef56e7d70d39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa4d5647a4343df93a0b62060dbec981966a04e36c82d2887f78b02f3399aaf5"
    sha256 cellar: :any_skip_relocation, monterey:       "d8ec03ed376bf4e3d33c95c77af431dbb2c334037d1728a8ed2bdef5d71b272a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9516f10a0a7724d68c4de2331de26af739dccb5be4ff9542abd71bd44f3a6320"
    sha256 cellar: :any_skip_relocation, catalina:       "8426e5962a4fa60154e479527d75cb59e424693e11b16216773cd9ae38427197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3b04dd1d9ef4f5399dd0a94e2460cab1059dc813c60442ed9c88d159ae17432"
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
