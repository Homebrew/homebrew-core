class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "498f3ea4882ad0c32199d375866e0443d68e79fc158c88b24ad0bf66d8757bfc"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dfcbc388dd126f589dcf8d7125553f55b3a22ca6fc90057efd24297ced01a23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3a84c9bd3b3668a82d2f27945ba8e3f1415862541ec4c4b19a44cf0dad182d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b5ddbecd0e6d4fc55cd4c3b4e3e9f3ff3670d83680d89972a70d23b82de16c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9de247d4d93547f8240c3957f8de82681bd810f484cfe3ce15bca9a3fba5be7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c970ef21388e8efee8c56dfc8729e9f8a49acef15d8eccc645ab1fca629d4491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "572a8475889909f1d982a4683eecbc5370a6f8b7aa9f114c7588b33f9e1d1680"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"

    generate_completions_from_executable(bin/"aws-sso", "setup", "completions", "--source",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
