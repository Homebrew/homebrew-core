class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "f9c441d5c36d70a4b2dfa1f5371b2ad442fa9c8343624998b952c5e9c3c4ee0e"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47cbe3ebf62c6ad40f940893a3967181be03597032d124c4f1313bcdb29dc399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75bacc23cf269f605f0fcc8791490ed8c08b7539be00297744447067eb50eab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "763f7e1ea5abe609469a11e34e688aa2dc332803ee55ed0a1202abac8decc468"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0be5e7fe6968c1de78669c6ced331aff08dbc7aceb07426fe8eb64701f5ebd1"
    sha256 cellar: :any_skip_relocation, ventura:       "bb9e6ad54651357a90d9f07c8f105d818a0f1288d6b9ad0b3978b0d3af351d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b2d203c751c2e8f82da0e47cee7468048826b676643e65251d615d335a97d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
