class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.15.1.tar.gz"
  sha256 "ea7a16da061082d2016ec058835ec7e7e42f42cd6f3fa94fb455be8157f9ddf6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d64903472b3435f43014ec39be72d8cd3380a7afd9ddbdd7b9ba76627d0da0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d64903472b3435f43014ec39be72d8cd3380a7afd9ddbdd7b9ba76627d0da0b"
    sha256 cellar: :any_skip_relocation, monterey:       "94a7262c0dddd27239b19e53a71fdfa67e592f526962da0822c939766be878d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a7262c0dddd27239b19e53a71fdfa67e592f526962da0822c939766be878d3"
    sha256 cellar: :any_skip_relocation, catalina:       "94a7262c0dddd27239b19e53a71fdfa67e592f526962da0822c939766be878d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7c76119c6b06a85d1a761bf55640d5488ab293bf8c44029810ba09ff710af98"
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
