class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.6.tar.gz"
  sha256 "4bccfdc2feead094e39482eb58ded08707880b7f2416d0b606a71b25faf3d583"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b2801846303159c8828142a989ddfeb6d90c5a8ccc25674a9c2092f9c0d8418"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4bbd30c0e90ae15e8c9c43bfe3ae87f49d97b1a1b25e175862b8099a6016ed7"
    sha256 cellar: :any_skip_relocation, catalina:      "d4bbd30c0e90ae15e8c9c43bfe3ae87f49d97b1a1b25e175862b8099a6016ed7"
    sha256 cellar: :any_skip_relocation, mojave:        "d4bbd30c0e90ae15e8c9c43bfe3ae87f49d97b1a1b25e175862b8099a6016ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405c1231a24a5fb490d8e747e9ac3af3be61752da82640ee933705fd89e126a3"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
