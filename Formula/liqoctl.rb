class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5b78f6ce6d868868a57e4bfa6ec825dda7aa1075be0fefec70d9b1ef2b5e201a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce2e1e9a8bbdd25c1a77ac3dff6cc2a7be8d1a26f9e2c772eacf3137bff032b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce2e1e9a8bbdd25c1a77ac3dff6cc2a7be8d1a26f9e2c772eacf3137bff032b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce2e1e9a8bbdd25c1a77ac3dff6cc2a7be8d1a26f9e2c772eacf3137bff032b0"
    sha256 cellar: :any_skip_relocation, ventura:        "6840106cb9a64b02565797f7e26e21c5e9bd289e510a6468d350280f2b4d0bfa"
    sha256 cellar: :any_skip_relocation, monterey:       "6840106cb9a64b02565797f7e26e21c5e9bd289e510a6468d350280f2b4d0bfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6840106cb9a64b02565797f7e26e21c5e9bd289e510a6468d350280f2b4d0bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b4277364b3a7bbf19a6b6b62d4cc7fcc0c2d314227b87fce005db00e98960a8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
