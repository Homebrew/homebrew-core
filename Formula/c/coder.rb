class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "c340936b8c3c7efd81d1321bd0cbfa08a44494e95a299b2193f012db2834cf87"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "725ee866c83bd7c08baa74368105a48f910008710c8200c718bf683eeecaa42f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44040398b750803bc232f627a91c3f49d5e3ef42fd611fc881b379e45d187399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e62bb2718e130d92481b69cbc16e984f02bbcdf83329fdf723f41064ac2386"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e77fa370e451c6f0fa7b4671872b08227ac21bf2eca12f875bf4b4c7d005abc"
    sha256 cellar: :any_skip_relocation, ventura:        "61c5bca768213ebdbedd9608b7c20dbf446f9f3a82a2bbbe233f35a114c69273"
    sha256 cellar: :any_skip_relocation, monterey:       "f7aad7cd49a5a908e3077bd41000f7d3eb4e1c24fd13bfcfd45592805682bae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f4051690e5435c65b29585c5cf3a563bf48d6634efe2ec605b98649fcf070f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
