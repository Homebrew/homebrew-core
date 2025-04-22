class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "0da9b24fa05343531862da3e9180972cc1ba0e6f3b1eeb8dcf0256f83bfc3018"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85380ededb7bafc69611c27eab195119bf6c1597c4d102cab5f9b727e7f3c269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "858b3d95d752bdaddf51f20b85d7de0cc662631019e8f290bd799e4e1987bcc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc5812b2e26a10a23fe666ca9713cd34db6a6eb867fa6eab5763f1aa6e5dd50c"
    sha256 cellar: :any_skip_relocation, sonoma:        "60e4ea54b37c0db84f8872a8ea70dd3290256595bf6aea5a8ba96e6a201da291"
    sha256 cellar: :any_skip_relocation, ventura:       "42089fff116a885157779f0b98cdbd8d4a155f7e71c7949c06d52191128fd623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35bba9c393b0df286aaf3db23f4ed05aa6d6cac39b27bab1083d31a08f1df55f"
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
