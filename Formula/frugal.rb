class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.15.tar.gz"
  sha256 "ee9e3c9bddbc2242b7c59cb63113c951e99ab85e2b90b98ef352b6e7ed92a194"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37f2777d2a3210415f9c9b46a1d76de540e9c3c1e019ba2511f16a25c5bf3a11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a978b8f63dd71a5bb17693cb94be7f1ef88519d205b31be055cdf0e85ab8656d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eea1b57015248f9a98dfc906244575e6e71fda0bcaae9e7e02e66272f2a4b2c1"
    sha256 cellar: :any_skip_relocation, ventura:        "5d5e8a82d98ff99f28e5a98ae7765da6210d153d988e7cfadfa8c44beb08c1fc"
    sha256 cellar: :any_skip_relocation, monterey:       "8891a4e770cc7eaa4630f41258bfb48b47d84f76937e08504dc54f8bcb303a82"
    sha256 cellar: :any_skip_relocation, big_sur:        "abdc80305fe5fc14b4caf45ed760151bc5e7f731bd4ac9ea78439e01310b6ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddb848157ccec62691c77ae0d95939c89521b3d82c266d398c99681e5786f1d6"
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
