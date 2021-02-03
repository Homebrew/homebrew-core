class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.13.8.tar.gz"
  sha256 "df3af41cd16c31bd90ae433dca2ef3d8e267d381f67612deafb024c946e90526"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7455d5ba91aaba04ccf8c1e5db02ce04b7165ca688bc2233602b25448ac65db"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf5392a63d13bffcbdf85be762575970f90c471d0cca69829f8fc4c833dd342c"
    sha256 cellar: :any_skip_relocation, catalina:      "1781baba66566339ea0626d1614e80c12e1c2c404f91052c28ca855bb8b47a48"
    sha256 cellar: :any_skip_relocation, mojave:        "46bb12fdaac564a75ae077c9c866f229b6ded2020c3d162fc0352c751354059b"
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
