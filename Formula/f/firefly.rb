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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "943dbc946523546a3c4b775a6373d290993c8d0bd07e0d0381e1cc4e77cf81ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd0f8daa3f920d243b7b392cb5da1fc85e81b815b552986aed651022aa049108"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "678aa4fdcc452e75b65e81bba862e72be253acfa98d2ff32cd821dd150427457"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fcc22601d4581cbe07d0fb4be06d86de7315cfbf4a309b4f279cb62ff8f81e5"
    sha256 cellar: :any_skip_relocation, ventura:       "45e9c74fb60e7347f00f85041af876938a17c569eaf01e51718f925e02da8165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79948f373e847c8d3ac8c2ae65fe5b2832a5d0e29ca307a4bd6b4cbd40b40df1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/hyperledger/firefly-cli/cmd.BuildDate=#{Time.now.utc.iso8601}
      -X github.com/hyperledger/firefly-cli/cmd.BuildCommit=#{tap.user}
      -X github.com/hyperledger/firefly-cli/cmd.BuildVersionOverride=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "ff/main.go"

    generate_completions_from_executable(bin/"firefly", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firefly version --short")
    assert_match "Error: an error occurred while running docker", shell_output("#{bin}/firefly start mock 2>&1", 1)
  end
end
