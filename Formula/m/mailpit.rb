require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "1bda1d7a035f0a996fe3e8e5256d255a8e0615e0b7f52381154df2c046518c7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2c450d491e33771b65ea2ee31bfb18a4def4aa07834dbe5e83e7e7d0c05d70b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "660a29768fdb2975bc64c19a8ce2a49d025de4da7e0d0c09181c9f696b631c18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd35518e1654e08dff4da7d1b3018f3d298a2b357c55edfddb2f7bc4ea2280c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "736e75bf14003d03042301f7f28198d85fa353f669f8fcdf640895f396675b65"
    sha256 cellar: :any_skip_relocation, ventura:        "49d4cd5b340790f8d2b8d9018edeadf8f17b4e4a822bc0125b8aadc65acbdf26"
    sha256 cellar: :any_skip_relocation, monterey:       "2f598e62b4c559cdf8aabbd4a2c2319e9ba5854f6d787eb13f01cceac342618f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104ebb90f90a31df8bddf5db1aea771a57cd83d681d65a5afb157f93f8d481aa"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
