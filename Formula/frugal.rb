class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.12.tar.gz"
  sha256 "fbb78c26501ac9671db41706415cc699e6af6a7423aae5d31e6fb0f7e0e4751d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3885e79c756ab957bdef0d319cdcacd2aec5a1fd74758d33ee6f1a8abe875ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2543ee83a6af7c61d0157acda8a28d400d3468aa67102c9fabbd6fb6d64b9efd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8b59ffc779668572da04c208d95801423766ca7511a59523a16035b4020463a"
    sha256 cellar: :any_skip_relocation, ventura:        "a6802dd16a95d0e7122e7958edfc09712b3c7d3b0fd55105429377d36c21daa7"
    sha256 cellar: :any_skip_relocation, monterey:       "7f711a28cdfe62adf064f3cd71f13d5f6ff06e09832384e80d641b50b24ebe04"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a315fb8598e5ca60e46b3f98be1a40181aab4cec98674096059ea9ee8288a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20753a28f1c7f617750aa84a5afde94f101bc209c437b46d80b2d138cf9d284d"
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
