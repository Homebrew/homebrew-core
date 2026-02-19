class OtelCli < Formula
  desc "Tool for sending events from shell scripts & similar environments"
  homepage "https://github.com/equinix-labs/otel-cli"
  url "https://github.com/equinix-labs/otel-cli/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "331a76783974318a31d9ab06e3f05af488e0ede3cce989f8d1b634450a345536"
  license "Apache-2.0"
  head "https://github.com/equinix-labs/otel-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a313a9133dd11b8af9799ab905e85d5621e0f39bf352644e507b50d917acf8f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a313a9133dd11b8af9799ab905e85d5621e0f39bf352644e507b50d917acf8f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a313a9133dd11b8af9799ab905e85d5621e0f39bf352644e507b50d917acf8f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "58427fbc110afd673b17749c06ab3016b1f068871e16d7a652aeae0a21231010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c89926433523c86889f4308e4e39c05a68af344017b877911d269b68f66118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad99c92f5002dcc5dd39e9e1cb4206ee327e6ef5514842fb972b4874a8f11ae5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"otel-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/otel-cli status")
    assert_equal "otel-cli", JSON.parse(output)["config"]["service_name"]
  end
end
