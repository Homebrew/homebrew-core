require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "c8eef5c6379ffc3e66211d055d7919589f9ee85bf74272c83d471bf1d4d12444"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8734c57fc2de7e196b853dedcf25769aec7c70b76a3be256423fada2534d5070"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cad68679e95d81277406473e78ab3658d2e441c7989a813aaabe523a3c3c866"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52bb0aadb8f2a038007b5cd48b885f764bb00fbcd709032e3dd8ae0b1d4466b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c59e23c30b569b3ac36079795adc16431d8f172c1485456247cb6fc58bbeea8"
    sha256 cellar: :any_skip_relocation, ventura:        "090159929e24e1261a1df40ab7d3a86667656a190e0bd0d880000e17b56ecb03"
    sha256 cellar: :any_skip_relocation, monterey:       "6463bac7da2a27068945b0f7730f73b582a658409ac9a99d7c3fd8fe2e5d4eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c402163c26ac59f1457cac7c76b91ef9f188b77550f0ac3b674f467b416d8f"
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
