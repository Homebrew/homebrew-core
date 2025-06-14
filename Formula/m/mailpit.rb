class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "ec9a87ad777c7daf3e1ecfd731ad5728b51c177d64ec14f1eba2aa5748118fa6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324cc0ffcc19a83c543af76668faf60187a3f7c9d9fee0090d267f437df49d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a2cfc02c1de948eb03955617828b948510f88a77398e5c45e6f0ab48fb3ee7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73032fb234afdc4e02a7e621f8bdea8be25f85b71e39b7a25a057629ae19c502"
    sha256 cellar: :any_skip_relocation, sonoma:        "c406306c179c4dce84b952dadfead65be760413b37a2470e88c27bfa8f92ed0e"
    sha256 cellar: :any_skip_relocation, ventura:       "d0b67d62628ac9ad18c380c679d92fb3172d4395e895e1bec010da5119759719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02ca39f039ee56c675284373451cf4b2d8e8b598abe3253009d537f6f4318c8"
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
