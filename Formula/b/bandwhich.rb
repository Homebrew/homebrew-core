class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "8ba9bf6469834ad498b9fd17f86759a16793b00a6ef44edd6e525ec40adcb0b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcebd98b376d5d4daedae44df8a2ba96efc2f368fa8b2051ca809c0351bb824e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0532e0d9c5876fcc4626be1f0cefa4ee49070d03765a0cc46d2bc9b94809812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cea0d04e206233cfb47cc1628894c545eef6e78ab5672de4e816a6d02698eab"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e50f6b59e748d752b9e340a2d0a007f588ab40f1ff6567a734062db3ad49323"
    sha256 cellar: :any_skip_relocation, ventura:        "07452019f6a584b40b1dfb1ce3e80b5a17948d4160797ce2f249ef73135a3da0"
    sha256 cellar: :any_skip_relocation, monterey:       "0b0f18191d5e2b86a1f1d006311ddc98a8e82d1d29e8146255ae10dab3635979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180bf13277dade643c02c0c3f621a65587e9d651c5e333d01906266085af7784"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 1
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
