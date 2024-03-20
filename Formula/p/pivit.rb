class Pivit < Formula
  desc "Sign and verify data using hardware (Yubikey) backed x509 certificates (PIV)"
  homepage "https://github.com/cashapp/pivit"
  url "https://github.com/cashapp/pivit/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "aa4668180c6b533fc027cc6e06e09c122edc17a87d4ba87cf9e56a50fef0ebce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "591954ea53ae181d7745d636ffe68ca59fc0f165d8ad9e275b091f3c94cb7784"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d316371b0a2807644210fe84bb4de7c8b9b1ca7ebeb4ec1311d11f30c84ef1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1608d3741f07bc4a34f6b1a1c600872dfc69cc5d0b44345f8d31c271ff15a02"
    sha256 cellar: :any_skip_relocation, sonoma:         "507a1013fd3370ac5f7709e182b9eafb1373a095d2968a0c03a4db99e151821e"
    sha256 cellar: :any_skip_relocation, ventura:        "23c90438fafce78fb7d1f255b889a0fc884c6a1b7065c0ecf1c35ef439827ca8"
    sha256 cellar: :any_skip_relocation, monterey:       "7d9cc41a60c819c74d71a6b10da8e03b8d09beb4dcb22070fc40cb4c73fbb95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f711fd9ec989fbc62da4701c2d385c2958edfd503d7788b695f56904a908848e"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args, "./cmd/pivit"
  end

  test do
    output = shell_output("#{bin}/pivit -p 2>&1", 1).strip
    assert_match "the Smart card resource manager is not running", output
  end
end
