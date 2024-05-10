class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.48.tar.gz"
  sha256 "149641e1b263bb8d3a6c6e568a8b40f77207d7f881938908547e402ad51f317f"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72c79b00b0d05fc9fefb78904fa2abc46fae1bfc2ea6b7c81c56235ea7305026"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e6c800f2a69bf46d61cacd5f71018e62742e2e47c906b7c65f601e285099cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63cab82f40b9d40c9b1255b017976036f472cfe448e43546d3ec105f0997a88a"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd28f9a57d398616b974f9699c405e6ae69a004e734baede52f4587721cc2946"
    sha256 cellar: :any_skip_relocation, ventura:        "01242f1d686e2f9eab4e930a619b2995f04b52087eee86a6a393ae4707cc5d0e"
    sha256 cellar: :any_skip_relocation, monterey:       "0f37cb10e919cea174f2fd92d0d8083c8c3c4ebde089e04f74c41e46f13fb326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29710b7c09ffa1fb58bb55dbbf8af2d1146437b538954d2393a69cd1d1726768"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
