class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.1.tar.gz"
  sha256 "9522d3df25cb24488e13a12a2d0ec1849c2f8c1b73d58fd07dd357d01ba6ee94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70da4918730ef37deed586c20eee522b1d41c5b4c9bb4b00b7952563b478d15d"
    sha256 cellar: :any_skip_relocation, big_sur:       "3be9fbd13c0e73cab776f09b6bbc6f350456447a4652d37bec22407791c1794e"
    sha256 cellar: :any_skip_relocation, catalina:      "cd7835d1d8169ecb4e2c28037075f9c5945378844cf97ea0916d4b12fcfc5e65"
    sha256 cellar: :any_skip_relocation, mojave:        "05c7ca224c19ee9b42f8894a3539fe8e99a6d490daf4683864a34152268f3cf8"
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
