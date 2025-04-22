class Decompose < Formula
  desc "Reverse-engineering tool for docker environments"
  homepage "https://github.com/s0rg/decompose"
  url "https://github.com/s0rg/decompose/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "802a1d155df0bea896483da4162ae555d7e1e1d5e293ec8201508914314eb36b"
  license "MIT"
  head "https://github.com/s0rg/decompose.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a6ac95d556532dcdb8ccb6bee22c93941e70d472d6fe2e2a04aee692e69fd12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a6ac95d556532dcdb8ccb6bee22c93941e70d472d6fe2e2a04aee692e69fd12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a6ac95d556532dcdb8ccb6bee22c93941e70d472d6fe2e2a04aee692e69fd12"
    sha256 cellar: :any_skip_relocation, sonoma:        "04959a2108da5a70a89780f02cc5691c39aa163d69921507743c56407b0353ac"
    sha256 cellar: :any_skip_relocation, ventura:       "04959a2108da5a70a89780f02cc5691c39aa163d69921507743c56407b0353ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1de0150f4dcf6163ee980363062881828b21085f5a44f38a1a14fad124a986d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitTag=#{version} -X main.GitHash=#{tap.user} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/decompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decompose -version")

    assert_match "Building graph", shell_output("#{bin}/decompose -local 2>&1", 1)
  end
end
