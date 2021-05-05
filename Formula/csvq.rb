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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e24f11524a3b39f9ae2f171f4059cd74d02c8223915a01c88975ba1fd9631fa0"
    sha256 cellar: :any_skip_relocation, big_sur:       "172d710dcaeab1edd2fdadd22019c3680395da5cedb3a9089ebae89968413995"
    sha256 cellar: :any_skip_relocation, catalina:      "d26444b44444f31706bba553015e06ee42a0430fad18493193c07f05888dd50a"
    sha256 cellar: :any_skip_relocation, mojave:        "f91e044075488c92c663c50f0ed28530cdf375f60e582bd4e569ad7f4740a4a1"
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
