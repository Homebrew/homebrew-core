class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "438581a2fd717d12b6259081420b10a8dab5af30b18b73c01db9cf5d83467869"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fdb8c1bd703f6cc14faab77839123ae3d2effdeb517a56b59b14edc8f00de5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5315a3efccfb4cbaebedd5e1a7d0aff1a08ac90751670a0c9aa00728fe89e0d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4868a43e21e7337273faf747103bbaad5a7bdb354cfc5f645ebcaa0212bd366"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf9758f2328ac43fb40e2ab8912dd587402e64af053e6f02994d6dab23cf3650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2adc604c429177950ec9543b0551e8dfd7c80c4ba0e4c76df53f14d0a1c8adb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807cfc4326c85b02236c1fba8145231377fd1854c1c8022b933d40dd9905f6fd"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", "completion")
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end
