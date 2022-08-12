class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.10.tar.gz"
  sha256 "dd216a1f304d2b0af3de98c7df56b5eed0fac7fffcb41ca635118b94ee4385f5"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7232d6823c77aa212c1cc92f2c646d090b967909a53c4db051cd695c9e43f81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7e4c6f4be87d482534bd4400ccbf7ecbcc03d81107351e72384279e2f58f05f"
    sha256 cellar: :any_skip_relocation, monterey:       "386e76b2f31c626ff68f1a2ab89d6413968e2d0481dd5e2d78904e2ab7f319b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9daaffddad494d15e576726b3ee6cf457c252efcf3fbea6f06b35fe55f650e59"
    sha256 cellar: :any_skip_relocation, catalina:       "386e76b2f31c626ff68f1a2ab89d6413968e2d0481dd5e2d78904e2ab7f319b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "072d0961a94d394dc4ad52546ca98a20e1d1346482b468743becb0f5ea0bfa66"
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
