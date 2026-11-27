class Nats < Formula
  desc "Utility for NATS Server and JetStream administration"
  homepage "https://github.com/nats-io/natscli"
  url "https://github.com/nats-io/natscli/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "6a735b879a19a7abaa4b45e512f23ddb7df6e8f1cd14b32091cd8568e4e94f63"
  license "Apache-2.0"
  head "https://github.com/nats-io/natscli.git", branch: "main"

  bottle do
    manifest_sha256 "4f37043def6079fb9e34a24b7a209ce4d13faaf80a5e99d971642ab84c27adb0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07aed02a4a5fe3bd4bd9d7e4b8da97ecdc1fbabe45298d4487da3e10bceb1e53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b271b304a8c9418792983c861c00232599d4dfcd045b9cf0169801332c4e2787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31e0b7d725783d7e56709f77bcc6774af780f3852cc507c848af36a35f28ea8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "44684d639a69f983b3c22863b57f3d1af8273b2d121ebab9d992ee3b7764f4ba"
    sha256 cellar: :any,                 x86_64_linux:      "b74b282f6b1f77ab1ac62e64cc838c06c25325d90c46402b78b61056c013c9ac"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./nats"
    generate_completions_from_executable(bin/"nats", shells:                 [:bash, :zsh],
                                                     shell_parameter_format: "--completion-script-")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nats --version")
    assert_match "No known contexts", shell_output("#{bin}/nats context ls")
    assert_match(/^[A-Z0-9]+$/, shell_output("#{bin}/nats auth nkey gen user").strip)
  end
end
