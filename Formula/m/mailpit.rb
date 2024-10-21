class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.20.7.tar.gz"
  sha256 "c6f5e4eb6340d994c35f91d42745f034416b131b97adb9aa4fafed804b12de30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e1fc90142a44b3376f9f09261c119743d739d913ef0c6b953e0a56455ccaa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f1d91b8423f9c49485fa7b6b25e44aa5bca27e2d92f6d7e20d220072ce3767"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "063d76f2fb18efc28f73915831912875bf9ab4ecf741fd2ba00d363d2c43f7cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b797cf6a75b79717f5949cf6d8a0ff47adaa3e3ba5058b82540418d30610a3"
    sha256 cellar: :any_skip_relocation, ventura:       "ad5c01f071c1c3c3e61e8f799c9753602e75e6e03499e0e071cacbf999399f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8b2b85c5a602e212b3c18927411eee99e7b711b0516ee40d0c2946c30a552b9"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
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
