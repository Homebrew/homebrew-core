class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.12.1.tar.gz"
  sha256 "71b8280d1a69d9e53274e2b016509747b464175c51027a1b25d8701a9fdd49a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "21af8d1ee88f50f219d5d9fc61a95c7c3d972e9aa7773bdd0fa269452612eb63" => :catalina
    sha256 "60e6b51a489e350c0d3dfb86e9a8fb7f91077608264a1ba3a90ebdd2e61ac6cd" => :mojave
    sha256 "dcc10b99f036672d7810e76e0bac83af35b51ba9688ed784ff113293931b3c60" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "csvq"
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
