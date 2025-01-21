class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "01c03c7eba34e04a4ba0fc9d0b1f08d9fb2d6b101f5b997bb2d9dbfd8ef993d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9220f727704b83e386da21190faeba77b7d77b72f24e8be3432a9908a4693e7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6f826cf9012555b61a5b3d066e24fe911a63973e5c5b2277de51855ebad6f32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6f826cf9012555b61a5b3d066e24fe911a63973e5c5b2277de51855ebad6f32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6f826cf9012555b61a5b3d066e24fe911a63973e5c5b2277de51855ebad6f32"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bcead3252b38472731c02ad8bceab56e8c3980d28dc5d6551bbd9812a231ac0"
    sha256 cellar: :any_skip_relocation, ventura:        "4bcead3252b38472731c02ad8bceab56e8c3980d28dc5d6551bbd9812a231ac0"
    sha256 cellar: :any_skip_relocation, monterey:       "4bcead3252b38472731c02ad8bceab56e8c3980d28dc5d6551bbd9812a231ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05976ada5aaa96db26b7f5ac331204fd2b10ac9df13ec944a2283fc6192dae0d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
