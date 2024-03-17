require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "47a12a1febfb967cfa33d0f3bc0137350ce8d5e7ae046fe4522c0c636a245126"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e49336b5d4cbc339abadafccdd02b3b468ff48a3f260a16ce90f6820e2398132"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d66e9fd2a37326d00636c64100fdf1d7de392b5244b6510ecbffdbe77434734"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82beec2a86e708b7f7be0fe902aa444a8bd0fb0772cc82230ff6e9877bfe5d1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6d561075e6ebe46d9886ed2ef52a2426aae22690bd084974005f078c7f2f3ae"
    sha256 cellar: :any_skip_relocation, ventura:        "2626c84636e27f1b35e29ebf5a4a0057d120b9bd9e4ca355712578cf093b5748"
    sha256 cellar: :any_skip_relocation, monterey:       "6cc1b56dab1237fb4a6c94c6b77b758f8e0faef4a3d86a1e2b416b2f37cb50aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3de0a16253a5b5df136f75fef85d854137290f014d32a5db6b03ef4763bb056"
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
