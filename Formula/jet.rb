class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "6345ed0ea92159ff2648cc1b4154478da8a2b16a61d47c74e394169897ba8130"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dc3bb817dc0d607a05a3141a26a451510f391f80d3b571658791a791e2b6e1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a331fd82d6417c13afadfc3ff8ca80eb2b55f15eb44f55e2f3eb2e24ebee7190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e13f0b4999a4a7b25f769ca2d50cc3005d22d3495693731399de71ae4bc7c578"
    sha256 cellar: :any_skip_relocation, ventura:        "291b687d8c6b843d7013f7f87123f72d715c221795c03ab755da27c11b306f16"
    sha256 cellar: :any_skip_relocation, monterey:       "c6e29ffe4ad4881c6b2c3bf1c3d4a2830536e40873eb78304fff65c29daddcb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8358431932057e2018ee8e3c594a9c9d969779c21586724f998c3cc1944a9e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9128a05d3b1d5c9cfa8c265621417eec43c210dd5294f948e49132a093ec67d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/jet"
  end

  test do
    cmd = "#{bin}/jet -source=mysql -host=localhost -port=3306 -user=jet -password=jet -dbname=jetdb -path=./gen 2>&1"
    assert_match "connection refused", shell_output(cmd, 251)
  end
end
