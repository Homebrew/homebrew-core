class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.4.tar.gz"
  sha256 "77ef872d3c6d2565cc77b694c98b997c63ee87f6abfe447ac5ef788ae924c97f"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36013afe18e8deed493eb806558fa577848642c4b0353cf45f88949935e060ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd604009f9c7f2a2f51175cee024e4716581996083e5a1763ff0b3ca27f3fcac"
    sha256 cellar: :any_skip_relocation, monterey:       "397ab3e339c2bb9b76ea531ce70436d120c990ebf93b0c88b24d4cff74c973b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7298975e9f828322e0fc06c4890b25fb0ccdcc529bf116562aa7dc2692d5761"
    sha256 cellar: :any_skip_relocation, catalina:       "d745c8a7b59733fefc9da5dc488fe3ed05ceed98e9bdf2a3d4cdcd9730ca5443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4719bde7b1127c0d83b5539fa885e887b3cc905a5016279f31ae5bb2149392a"
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
