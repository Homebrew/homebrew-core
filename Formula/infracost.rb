class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.4.tar.gz"
  sha256 "2ff566800087c2e0b166643287f40b87b6e6daddce05c27bf29eb8b66831b204"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fdc8aaaf3b235ac9420a01cccc9606078658bdecda504e19010a13ad9c9300b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "0521d63d086365954630edb5e3aae953b18b1f15ec306f4ee82631985ff42ba3"
    sha256 cellar: :any_skip_relocation, catalina:      "0521d63d086365954630edb5e3aae953b18b1f15ec306f4ee82631985ff42ba3"
    sha256 cellar: :any_skip_relocation, mojave:        "0521d63d086365954630edb5e3aae953b18b1f15ec306f4ee82631985ff42ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff94fc2fcc158264b68f823b4b45894b2c1bd1ba201f0c54b313daca45b97c90"
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
