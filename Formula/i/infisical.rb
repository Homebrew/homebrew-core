class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.40.0.tar.gz"
  sha256 "9ed56278e1fce3eb21ed56b78e58ebc38846045f1b01cd74d9f3dc81bc87f3cf"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c77ba5f1be4f2d43a2402086c0f61c62d89b7a4c9f54de05d2f29eec1343e46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c77ba5f1be4f2d43a2402086c0f61c62d89b7a4c9f54de05d2f29eec1343e46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c77ba5f1be4f2d43a2402086c0f61c62d89b7a4c9f54de05d2f29eec1343e46"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe775f51e7c77ff7307f815f7a7139b60b4512a04ed449e326ec361607f23e3a"
    sha256 cellar: :any_skip_relocation, ventura:       "fe775f51e7c77ff7307f815f7a7139b60b4512a04ed449e326ec361607f23e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1725e48fb262ba294fb409162a36904f720be420bb08bbbb151778767e7c466"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
