require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "1bda1d7a035f0a996fe3e8e5256d255a8e0615e0b7f52381154df2c046518c7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29fb033f6b14bd5507acdee83b4534b036d0683e9e58ae4589827ea1baf19fd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "258f2663eb194a336266fe61ade7a066354d5b2a3544d665ea162227f8d03aab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c068987824566e3d6bb2a7f8e4e55bc751cd74faeba9f3b54cf698d5e80627f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0943396ec2b7112105dd999bb9215571fbc2d790a604cdfac307351ee4f8ea76"
    sha256 cellar: :any_skip_relocation, ventura:        "9abe481c6eaf79ee44c1762ab67e941024bf40fd1adc9b729a886061c842de48"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1416bc897dc202c634a991b5aae63058a2e58c3946598f58f2e2e29f0f2ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f085b4495f6b148d87eeede4aadae48990a76417966360a50d99ca9a6efbb97c"
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
