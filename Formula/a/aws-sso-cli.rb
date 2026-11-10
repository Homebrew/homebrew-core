class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "1f82a50e23b2963811d59e0a64bba214d48bf82fba17e52aa35cfbf0a4d65334"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50a5bd9080c1b9412fc9257651a43e9f47cd971dc5945790a821a241281cbd9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff2c6b53e5c7b9eab1f2d2e5b8c1dee4f56a12330364fac0c5fba45932d07df8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7ce127bd4d52e770dbdf7409d8e5c706cd1508174ca061267e4e834c15590a0"
    sha256 cellar: :any,                 arm64_linux:       "de06148c4e31064fef2a69eb7cb314d1c107ca273510be7ae3b2b199de628a01"
    sha256 cellar: :any,                 x86_64_linux:      "fd00d808c8cc144950ff2ee06c3e1d2c4dd34c2f84faad4325559a01df4ebd24"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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
