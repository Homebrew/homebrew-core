class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.13.1.tar.gz"
  sha256 "02c480764f4d87217de3b3f068feee6f9ad08ee6f72b563fe0189ef90a1735cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4db8fb4edaccd90f4f5bd31c51c42001909320af56f5c222bd29a3bf18c15ff" => :catalina
    sha256 "7ffa2296999d643ccdc4e6335325273d8e8fd94872adad143c7e8ba098900260" => :mojave
    sha256 "10b13d56682fc1f10e2521fd12224326973f2a40108b1050c94b6dbbcfd6cc78" => :high_sierra
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
