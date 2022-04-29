class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.23.tar.gz"
  sha256 "740e6f5f65ae76e18576693c03aa586524d93fcec99451843d120eeedd8f32a7"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31c860d7463be1760b6c567f1eae2ff99324e66a4b5f088d6183a7fb728512bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbd643d1367f0ca020f5b61114c652caa3da1c89c7d0a8825310e7964a92639f"
    sha256 cellar: :any_skip_relocation, monterey:       "e03dfcc314a997548781daa22739376bd7f3263447dae65e6836b9834b87bc9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e03dfcc314a997548781daa22739376bd7f3263447dae65e6836b9834b87bc9a"
    sha256 cellar: :any_skip_relocation, catalina:       "660471ff02b7b431331eb6d492f7cba668421e0c573582770075160320ad1276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772ba5a09e3483c2ebf3eee8ee02c01e0208aa975d630892fb6f6e53e1bf5541"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
