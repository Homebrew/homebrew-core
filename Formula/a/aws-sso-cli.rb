class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "110b0a416b6f94c4654ac31b240395e415c642e4a83af11f0fad2126dfa9237c"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "696f1f95adeeea6032919881b25322e15f1782ac4627dbf48fdbb1c6ceced066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ba3ad28915d82ba6cfacb5f7946f6b9cf4ddfc83206d5403e5dcc964cceb6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d95806c6e2ab2a7faa35ad3e8531de2d9263db71ad764f20876075d0b7cf8ee7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8ee1a878f45ea44b7497241f9848086be764b3ded02c646242ec3f97cb26715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b0806fc89befe663292fb806278efc9bbf5382562b8dfc71f411c86332fcad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce79a5ef4f6bd3dc0a9dfb830f38c2d196d132d329eed15c9a4600a8d0f6ae6"
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
