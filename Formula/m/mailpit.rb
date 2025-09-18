class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.27.8.tar.gz"
  sha256 "18e9aa228bb7074338f5ed6153c874ee0dff722893cf5f5f1134682ab00dc665"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01c5e457fef1da728420316af53f208985750a37287c25ce9a4e4636b00b1b78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4558659fa404800181435a587ba34bc66d18a41282465d8c540b90df35edd99a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aa1a5d6f2aeaf8de3ee340f43452b4a97b03bca8f98ac9bfc9426170e185692"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b0956e8a1926df19f9a6cd2097cc6050144398a105b025d0fe6fad3a419eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bdf3e9582f01541a500efcdd1896c651e81326ad5c731fe766fac7da8441f4d"
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
