class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.8.tar.gz"
  sha256 "8d8a7b87ce7a260d1cb57034ea66bdb81ebbde3a00667e1ff83eb2bddc07806c"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "762c7a4822c042715a056e1a3fc6b0a3e29f73b9baacdfcc1821f3c06da361ab" => :big_sur
    sha256 "a0ab092baa39a4b1faeaca4708348b7519e9ec9fd2f406506acf3821fde01b7a" => :catalina
    sha256 "176f7e1ca835b8f6cfda2da1ce1824e2f80ab94aaa2ac08010a7a34d7b052c44" => :mojave
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
