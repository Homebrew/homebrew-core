class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.29.3.tar.gz"
  sha256 "4e80cd79ec2c7b4615890d680a420b1313630d500e112a8e33f9d566558b2adf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65aa7675cf2b03e2bfdd580969c305c860300ff913d0117ee6b4ecc38c9636ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7055fbf25039eb5ddfe56ddb7c3b6064331311fa55865f0a12555e10b92fb3db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f207e6574570eb869baf679cdca7067bcd4eaada3ca2f6fe0afd48915b69015c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a345c864ef89bda36adfcfde61796d4d28371d94c2cd7fec7a984b288ceb330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bebbe4b0c312c3075c8eef9ac4854352bc7e52e29621cbf328e335d99d2afcab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14b2d4f62031d512e0aae408e3c7205429ad45ee395892d126f882e8bb9abca"
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
