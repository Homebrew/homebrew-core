class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.11.tar.gz"
  sha256 "0186d1571af9cebb4c0d3c5e733c0a96bb735c7988f9c148b0a852301fcc89ba"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0f594dea7558e10769d03492995a408b5c6520a75e92eb1345cdce5af3aaced"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e179acb21c6cf614717d6227cbf3f0815036ed68307c976a353271feb98d306"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e6bd7e2afde2eeb690bbf4d30b4c5f81a12f1923d7e9a373e3f5746e90b6ae2"
    sha256 cellar: :any_skip_relocation, ventura:        "3acf6913cceb2978481481b2c78efd33bb129f77101811ed4fd74e0825a726cc"
    sha256 cellar: :any_skip_relocation, monterey:       "efcca045d162053b5d15bc5725c535cade60d18c06378fc59ec61bc50a22c30b"
    sha256 cellar: :any_skip_relocation, big_sur:        "aff68d822e0ef5d7acfb27141886a9f2d2e5742cf9f00bd17983b91f1443ca2c"
    sha256 cellar: :any_skip_relocation, catalina:       "ac0227a0cbb471d5b30bb322168f4dcc2c11039098228aea3b120798e2037bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c054f4e356cef7abc322b4beacea894ebb98ccac5830b6dc7e0bec37b2a0272"
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
