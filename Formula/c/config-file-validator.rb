class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "373e66f60ef03026f7efa3116fc5d64c04a6b7e88ea081d66eab8d69957293d4"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a58f44aadec8a1109872627b707c6a4358509a8e5ef377e68babee4f4feebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a58f44aadec8a1109872627b707c6a4358509a8e5ef377e68babee4f4feebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a58f44aadec8a1109872627b707c6a4358509a8e5ef377e68babee4f4feebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d511b2d4fa7be594876f6d3843382f90fa1938c3f98a1eda8d430185144d685"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d2daadd38666cca27ca348eb2cc03e76395de359a55bbecf265f3db81f3c8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc160061c3544a6f3f0dfb5b5b3857a09275b74227115fa8dd60cbdfa6707d61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end
