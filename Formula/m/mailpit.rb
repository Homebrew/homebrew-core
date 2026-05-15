class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "53e53ea3b891eb0c78191bc7cafdb9633bdc2b5582eb20ce45f12616f54c19a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9496387f27e61d8260cd273bdd1e0fe13eab5ef1632daed87fc1b6e5a6bd0806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13bd9a69e214fff8e9c55c64f3a67487aeb5e94bb0ad3b6425fb4a00201faca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2acddd3a4b6fb3d004a5e2bb66dc4695c541f2cd387bb8a3d3d1dde6016b58d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5816eb96b8a13ec372c67f7b9a8b6b149f640bce3c15ff7975d7e6839045aac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c822c9e246da9965c69528ec36994b87743b9915ffc3cb37a97c00540a25147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df84da2ab4cbc0996ae37376a7eb30487d58f29436da0c9be24fbf56c3fdcbc"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
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
