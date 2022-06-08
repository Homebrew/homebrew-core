class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.2.tar.gz"
  sha256 "f007bafa8592e3c33ef430eed397964b13eeb3ab3b2b0ea33fe526c3f53ae944"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0429b05f5d99bf32ee6b5871c4af6c4c60db5f34f027fb7741b844ebc2a766b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3f4e5354e334bd171c8961fc52d85856ac9c894e978aa10d4ab816819a27da6"
    sha256 cellar: :any_skip_relocation, monterey:       "b26ae16a6b6c1dcbd0d171e7f49630721712cdb8b6f77fc661bda687299f2c69"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6f0b57293316e622d480705e136fd3007895c5b3bc7312cf0b088c6d896a783"
    sha256 cellar: :any_skip_relocation, catalina:       "d6f0b57293316e622d480705e136fd3007895c5b3bc7312cf0b088c6d896a783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96151262ba6859e38071af166746e16ecfa0e122288fd7a566e2b47c775a21a7"
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
