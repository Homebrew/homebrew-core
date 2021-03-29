class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.15.0.tar.gz"
  sha256 "0055bbf1fd6ae9beb93e768fbca8d8ab13d7f3f74e5ec841a92afa0293969a08"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c8b2112b0512f13d458a9dc2c538e3f3281dd6fd84719dd4a950655ca56604b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8cda072a643e88bec457457f62bae6d2815cf9408e7cb2a3b018842825d200fa"
    sha256 cellar: :any_skip_relocation, catalina:      "00f9d35784e9435fad78dceeef4db80b290de5bff9cba2fdbc5f17bc39bf74b3"
    sha256 cellar: :any_skip_relocation, mojave:        "7f76dce3c04cab5203f4710594a984d08c2062395b5d06e5a104907896768c17"
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
