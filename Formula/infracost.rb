class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.4.tar.gz"
  sha256 "2ff566800087c2e0b166643287f40b87b6e6daddce05c27bf29eb8b66831b204"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e4879740d46deb659ce6087f0fed176c0109d009daf4645804984e1d57b8f09"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0a4c71cedc4b747408b3fa5d82a6e9d02cb4c0bf5424301e0bcfc40fc485cf3"
    sha256 cellar: :any_skip_relocation, catalina:      "f0a4c71cedc4b747408b3fa5d82a6e9d02cb4c0bf5424301e0bcfc40fc485cf3"
    sha256 cellar: :any_skip_relocation, mojave:        "f0a4c71cedc4b747408b3fa5d82a6e9d02cb4c0bf5424301e0bcfc40fc485cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1023b9948619eb9ca5aded3b62bde8370df31a6bc93f4ac2debf612b418c2721"
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
