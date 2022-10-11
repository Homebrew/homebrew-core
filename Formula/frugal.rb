class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.5.tar.gz"
  sha256 "4b9c6e7d797c00e46271812e24d0f41d9f2b2acd7c054eeded05d87fce0304e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c8c3fd24dd6f65e205c4dea76b78c67c23ccedad80bf7ade2317606cafc3549"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c8c3fd24dd6f65e205c4dea76b78c67c23ccedad80bf7ade2317606cafc3549"
    sha256 cellar: :any_skip_relocation, monterey:       "755d3a86ea9fdbc3bfa72d520fb2bd0872447d8bd786b0b6b9d1f2b62590ccae"
    sha256 cellar: :any_skip_relocation, big_sur:        "755d3a86ea9fdbc3bfa72d520fb2bd0872447d8bd786b0b6b9d1f2b62590ccae"
    sha256 cellar: :any_skip_relocation, catalina:       "755d3a86ea9fdbc3bfa72d520fb2bd0872447d8bd786b0b6b9d1f2b62590ccae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "882e36a29349a815083962aa068d11b515a6749b6697d5c5e8b20a29c14b4042"
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
