class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.6.tar.gz"
  sha256 "ecf6950637c5848582f0cb0beb7bbdbc65be4574fe2814cb3e6d544984f00aca"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84d0e32ba598a1fd29d1bafa3f4e1c3ee32375d1cdf8fec12c2172a3dd5f96e7" => :big_sur
    sha256 "d8f55b24f100cdb018deeacb63172c8a440a9aa41a6b0d4d707e15a8321c1ca8" => :catalina
    sha256 "0d08d5c0a237987a45e55f60bb517e87a435b9a8fbed048ee13a7251641610d1" => :mojave
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
