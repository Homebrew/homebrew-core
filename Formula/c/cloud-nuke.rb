class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "6c9a6a1c64ee2099f9d0e69a784c807999d62d86a599927fe3e8d8b4caaff54b"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa53403d59a95f6d45848c839f5f8bb9ac49138928506aa5db4117476cd06c30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa53403d59a95f6d45848c839f5f8bb9ac49138928506aa5db4117476cd06c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa53403d59a95f6d45848c839f5f8bb9ac49138928506aa5db4117476cd06c30"
    sha256 cellar: :any_skip_relocation, sonoma:        "a09b9e2618cf78e09a4a82366aad60bf1f31a5881e1df0d4950ba25947fad97b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "841cdfeb91d3c450afc4c8a61d2ca3ecc5c57c75c11745f31d871f2cca8a68df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637978aab39b5b703ccd62bde01b4cad37f23979cdbb905517ee74e994b19729"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
