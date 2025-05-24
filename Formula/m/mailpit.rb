class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "a07d67df485988ecea25b2db9cc91b31d64c3e6c655e61ceb3fb6473a5815723"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95b0d0e6f18b326447141950e9ca329994180bfe06e4f0d68a4388e5e0d897d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8438218d75c465cf33eb5dc89d7a6dd1b19f393a3a5411da55aa764d84b48dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32785bd35c0a04a0f78717a22e4ca47f3b4b5bf50db57967e946d91cf3daf999"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba9df34dffed2646f9ee25c75f65ca0f8ac054a692f2fa94ac20614c83e20ddb"
    sha256 cellar: :any_skip_relocation, ventura:       "87d70f6a93ea32c20360099cd4ca5362858d57267feabf810e028c2a87754c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd04af41fab488822da1872b4513b3329c1e3aac6f1f1b4aba7cc2ecfaf12bad"
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
