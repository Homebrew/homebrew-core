class Firefly < Formula
  desc "Create and manage the Hyperledger FireFly stack for blockchain interaction"
  homepage "https://hyperledger.github.io/firefly/latest/"
  url "https://github.com/hyperledger/firefly-cli/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "05375efa4e849695c60e70ec3e332b7a4c8dbe666f1b76b8de3f12944b85b60c"
  license "Apache-2.0"
  head "https://github.com/hyperledger/firefly-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa75e2365a7fb21b0182c1d85c270baa82a58e91c90ba670e2790810a9d5d7ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b07256aa9e5357de95238db4778e2913a7960bedcc5ade1caddea9ef2dc25864"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3deadfffd5fa2fdf3eeffcf18e6515711f1b01d9729ec98df5e65b55ab29201a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c19b1162fc6fd74ae127d982ccfb5960882014297adda054e7feab87615b21e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a6e76d023ecf1e34786eb215cb68442c6fe258b7680f0fbd511e21e1200a7dc"
    sha256 cellar: :any_skip_relocation, ventura:       "3308f1b297227d14bda4ca2677fc43d84d89b4209f608b2cfb284b978b345c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4a6c6b4d81f767e2ec31f98c91dc6af6cc0559c131389ee11a2d2229167f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa41229e683fd285dd17a4a1c6988e7e8980cdefcacc7ca65d5480203e2e77b"
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
