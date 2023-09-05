class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "06e53602f89a5ba9f595f54635860f01a5fa3562041f1efb40bff4859ba52f51"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6545f53cd3611aec349985a9901867289644e6d838e5d2a907e09ac35eec696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "332ac6dec3294c9fbace115e5086ac2eb5b462e275adaec057528e38f8ad13db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb6a9404c5f08be8eb9e76f395bbb42225658df44a514b0b0048b9536123ca93"
    sha256 cellar: :any_skip_relocation, ventura:        "8da63a00d7df5b5bfd16d35d43fb3d36f816c590316e6b6a3c6d3984b410608a"
    sha256 cellar: :any_skip_relocation, monterey:       "cf325295c012c2a407f4f7c23f11effdaf9a5dcd1f334fc6148704e2859235b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5054e1b2504b2d1b11789c044b670f64ffb01cd1c559b5db23eedfa84cfe3b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f85df4f3d1a3eb6411b602cc03be6feea77ddb972669fe125607ae33c1c1e6"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_predicate testpath/"ca.crt", :exist?
    assert_predicate testpath/"client.crt", :exist?

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end
