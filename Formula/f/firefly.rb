class Firefly < Formula
  desc "Create and manage the Hyperledger FireFly stack for blockchain interaction"
  homepage "https://hyperledger.github.io/firefly/latest/"
  url "https://github.com/hyperledger/firefly-cli/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "843dee9fabc787dedf5768735f353187349bb759583d5fa3c977969f3688e516"
  license "Apache-2.0"
  head "https://github.com/hyperledger/firefly-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44628813a1cb58358500b2c8ee071d4d75744b35aae40dbed47c90899b91ccc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "782a3f0b9cc91772c7fa488a8759035c88fea56c6be33b643976233375694c40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "193d5ff64fa0ba56a7ed48b9b9cd8120a36a546c824a8d701c157fa9cdf9e682"
    sha256 cellar: :any_skip_relocation, sonoma:        "70856574a48c873544469327015b3f382464deff91c5d84c0b96addeb686d127"
    sha256 cellar: :any_skip_relocation, ventura:       "67d4e4ff32859a58003a7b99c983d3024644688c8e75ea07be39635bb6701c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35a5fbde29e80405e4f9c6e47a241505b70ab03b2e51f280ba07fff976ca155b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hyperledger/firefly-cli/cmd.BuildDate=#{Time.now.utc.iso8601}
      -X github.com/hyperledger/firefly-cli/cmd.BuildCommit=#{tap.user}
      -X github.com/hyperledger/firefly-cli/cmd.BuildVersionOverride=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./ff"

    generate_completions_from_executable(bin/"firefly", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firefly version --short")
    assert_match "Error: an error occurred while running docker", shell_output("#{bin}/firefly start mock 2>&1", 1)
  end
end
