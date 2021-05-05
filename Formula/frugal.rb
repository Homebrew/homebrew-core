class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.4.tar.gz"
  sha256 "6a0e2c0d3e7ce18d8472ccbc66ee3f860d4dc562ef7aa32666c85657cc5f2e95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d42c28e3502043aa163cb786f02282f87942ec3ca71b00b1340cbc3ea113d3da"
    sha256 cellar: :any_skip_relocation, big_sur:       "81433cadebe1ac671fa196edf4533b66e66ab31610cca6a49935be058dd3b23d"
    sha256 cellar: :any_skip_relocation, catalina:      "81433cadebe1ac671fa196edf4533b66e66ab31610cca6a49935be058dd3b23d"
    sha256 cellar: :any_skip_relocation, mojave:        "81433cadebe1ac671fa196edf4533b66e66ab31610cca6a49935be058dd3b23d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
