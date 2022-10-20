class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.10.tar.gz"
  sha256 "0285f2d1e11eb3d571809d5bb4c2cf568b22c5dec68193c828b2f1c89f59da4e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32c77a4f4c69a1b75523af4767bf9a9b6b16141799aa01f370e05aa9b5612de8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "201bade79a136fe172b91154f5cea4f20866c1ffc2ab2ca0b7e1f0446c32bf8a"
    sha256 cellar: :any_skip_relocation, monterey:       "55ef3795fa0977fa726cf56d15875d0786f480612ae3532cb04cb77cb951eb5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "206878815431a29b9f7a74ddd2d8f7fa9256bda68a452fb08d19974a6bffb4d7"
    sha256 cellar: :any_skip_relocation, catalina:       "b36ae6f75dcb1af8051ac311bc40c956cd0f03e2cd235f33124132e913019ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff744d07f89372e4cacb2c31b29c3a0a9d449d3b91bbdbfcf22e9d2ce0e77b0"
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
