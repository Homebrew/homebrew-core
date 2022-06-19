class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.3.tar.gz"
  sha256 "b1b65b70bf908b569da4c127ccddb1bb4ad9859d0ebde5470a2d60176c5fbd3b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab68631a0b290f43ee26c64817194d0977615ab666b759d96b9f9703f5434395"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8072040ce8a18aa69acba8a9a0f4e9e427f872dc1d9efc1907f8aa8d3ee72279"
    sha256 cellar: :any_skip_relocation, monterey:       "92e14af2804855d27a789afa4fe86bc91a354a8a3b7357ba4cbc6a81834a4f51"
    sha256 cellar: :any_skip_relocation, big_sur:        "d09fa94bbf5fe9e60b646e8e5a72266c14aa887f256e4d002d388090b384df4b"
    sha256 cellar: :any_skip_relocation, catalina:       "f408fe731f8f021f147f28ff0f499420fc5017939c97db7ff382651ea731d33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "139576ac0de862ebc3c3265b58ef5187726edb4b5994f82230099b79da219a34"
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
