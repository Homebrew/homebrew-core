class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.13.2.tar.gz"
  sha256 "c94e13d58d3e1cc68168fd177d673662a76bb7fde88e9b9b8cebfd9af5db0089"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4db8fb4edaccd90f4f5bd31c51c42001909320af56f5c222bd29a3bf18c15ff" => :catalina
    sha256 "7ffa2296999d643ccdc4e6335325273d8e8fd94872adad143c7e8ba098900260" => :mojave
    sha256 "10b13d56682fc1f10e2521fd12224326973f2a40108b1050c94b6dbbcfd6cc78" => :high_sierra
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
