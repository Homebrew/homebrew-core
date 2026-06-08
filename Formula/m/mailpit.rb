class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "bda226e88f828215fc3646258494e71ebfaf82074970ea28a319c91a64c068d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b82b0acaeb50d5fcb0e48a68f6c37cb2e157125b7c5af064268ace297eacfc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae7509493de5ef2c533b270fa503e1d3d6633ba232509460baafbbab22570c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6426a19e2323798ae64eaa1741430a01d5c32ebf711e75adb62470cc5f0a323b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0042c9fffda142bf72376379fee323478bbd5501eb3fa990ec8d974d1d6094ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2efbc84dc6131f35cd87bced7f06bd3f74dc4f5f2c34fe4828cb9041ea78548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4605c5d15585a54ed7f743d7e280ea2d20f08d8825381102f31fea3ea983fcc"
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
