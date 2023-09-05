class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.16.26.tar.gz"
  sha256 "14dfb003adaa72dbedfe5e6ee1ecac62c565eb0262a642c9492e0c88ee778c3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "188a048e1627c851989dc35b5ffc5ee3acee568090df367a996dbb0f8a9a3eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb2c1b9f2be6f7e8692ad295bdc0dd985ecdfa3673dd6ce9cddb3cc222ab8cb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3740889294dba6eb6310270eb7c59037d732b756b8f8726b46f0f6c69f4c8b8"
    sha256 cellar: :any_skip_relocation, ventura:        "8a2e5e029aff5e835120c0ab19ab8442d0d69288e172a9ab6cc06d2820ad3b17"
    sha256 cellar: :any_skip_relocation, monterey:       "76ec59f3c74db96d3a43750872e8060d30682c8833d081d10707041cac6090da"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5cc4a0780183b2a62879e2386652b009ff51a79f95cf8f6d51f5b88c8ad4433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c28f8c9d81e30a855a79a559e5b6f4bbc451cb055903ee9c411b307b227ddcd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
