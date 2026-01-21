class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "a434a76acdf4aaaba8856396a1405867ff92a796e5cef4e8d62bad6ba8bc8374"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "266ff3dd81d64ef3caa27ab67f9cd6a9ca8cc390ffef66c025f0e2399d15ade5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31816b0e87f38a88bbb3720414f8d4afe79f33d91f593a674c2ab0ad92710f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18c4bb21b0f99b8e4170c7e0c4e6eaffa74470f815703291857ac3334a9f619e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb705c5b8edafa01ce611512a62be78f3f9a65b10df75968234553a367823bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af895d541ea6d1b4e7ad1baf815445ee8626f6aa507233c82985e3a237864b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58041147269c0fe51eeacd8881e67ef06165358150255c0e8beef52422637f4b"
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
