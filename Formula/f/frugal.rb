class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "84412419e955271698082bc2009d378b16c902578c0687fbc3df387e815be76e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6605292e7a94d3657fa12540389c1a27e0c4f41b7f94b7dfeb91f31e03488cd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34d5987fe0d56758a8b3a1d9bef5816afb71e64b24da6eb3bc4a60ed23f8ad7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e105620fef2e3688e70b850e8407140b938be94fd38c7e627ce29f7f49d0426"
    sha256 cellar: :any_skip_relocation, ventura:        "ab747e1a48ecb470d8bfb2f8ad19d8195b0f8227f85d296c24c1b9a12ef04072"
    sha256 cellar: :any_skip_relocation, monterey:       "9288c831e0d94a15187b582f67becfb76d1bed7443582b0bfdfcfbb2d7e876fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d183065cbccb7df7ce8df12e182f98b5dfb6a01212e364a4b4b97012d33695b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828c82793502ec08f9e48046895657bda8607c0b6fd354e2fefe1d40311a9408"
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
