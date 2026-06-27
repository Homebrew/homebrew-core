class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "239f044997dcb6ec27ed1b85b5ca3bba9d5996d66dad67014c3f4aa75549269b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75095a4dee5aff2fed1fa57f8af892b6f622b974e3ff99e7a13f025c9fe77f8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8369c57088a016e9852673b21d0b33f89206ca523c796725b92d9917f2f6ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da62066a28027c700069448a710eb0e3dc728973d524c6db778b465f8f2f763d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e42eecac8a2f88a4c6919b905569d52c6a549d7b4d472f834917c8d6e2c738e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "848423a3d88f2b5dd5c880c40e642aca1891bff14dca200839ac5326a7dbae16"
    sha256 cellar: :any,                 x86_64_linux:  "dbc84b47e8f61638acc9ab7c883c6edd4667543868cc4b4a717c81ab84b7cf91"
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
