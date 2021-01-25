class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.15.tar.gz"
  sha256 "e6df4fedda4fcd0abc0feadcfe3e1309794ba758dbe5baa7dc3de6c96e8acff0"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f2339f284ed258c845664e154cddf3b0560f7941f5c34eaf9b3e250980a5668" => :big_sur
    sha256 "066b7dca83bc8a899614306862d0b59480f737b22feaa1a2f6ec625341134dd1" => :arm64_big_sur
    sha256 "0ffddbf0d367c4f51ec869ad67a95ee19c63a267be6a2aaed43e3d18072106b7" => :catalina
    sha256 "fd9e368d9b0487731d8d4028284fb01acac68a440ce38aed20579fc96eb7310f" => :mojave
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --help 2>&1")

    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
