class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.4.tar.gz"
  sha256 "8616fe03e8357c75a7f1384596644a10d3aba64e83730e9606ad1ea7b95b8dd9"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e6acc93aebfb5e0a96164dc0eae7b3fbd5503bf853d67f087aa1135c4ba0df2" => :big_sur
    sha256 "ab82e0062a0aeb759a6192a891404efff4ba3dc0c721c33b87d214898f2266cf" => :catalina
    sha256 "bac8e561308e87d78f965b41ce72894615c171d37f4627e352171d0b1b233010" => :mojave
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
