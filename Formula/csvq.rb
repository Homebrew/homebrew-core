class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.15.1.tar.gz"
  sha256 "54c2dd8a623730f59e20058526ca79f68a93451af21207c314bdd3a674f7a7e5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9d904bb564189f3f7259c551d531f6cab9c1934ca91ba9768be068331f02645"
    sha256 cellar: :any_skip_relocation, big_sur:       "072d9ac521a701c89e2b48e78d7945d6643b426ee72be321405bef0fea0b4aed"
    sha256 cellar: :any_skip_relocation, catalina:      "e0c830968887bb1fa31d9e170ca4e4b188c36d0bb295cea8488fc62626f2e2c5"
    sha256 cellar: :any_skip_relocation, mojave:        "1522a3942e24cb0922f73950732f2c5e3d6c32f501e1168bbb24b2399976cba9"
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
