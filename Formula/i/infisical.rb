class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.1.tar.gz"
  sha256 "0b546f4c4494a3aa094e7c403878c2abc4fbb8f1b8d31a32b27ac30fcae5e3a4"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "696d15055447f35c057139c50a4cbc85a4f8e5ce7a1868622327d2fa53abf500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "696d15055447f35c057139c50a4cbc85a4f8e5ce7a1868622327d2fa53abf500"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "696d15055447f35c057139c50a4cbc85a4f8e5ce7a1868622327d2fa53abf500"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec31d005378d98eba8f40dbecbb08c7bd93b66c2d9f81216f92d218d802abb51"
    sha256 cellar: :any_skip_relocation, ventura:       "ec31d005378d98eba8f40dbecbb08c7bd93b66c2d9f81216f92d218d802abb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "514d589c40995a332d37481cfbd0eb97b50a97261849e4e2aff1929851ecb499"
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
