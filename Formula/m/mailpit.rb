class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "2bf80a5f2cd316b6e9c227f43c7f2be4f828acc4a687fac2a8fd5a384610b0fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b9afe747c81c9e033aca68f095349c3b9f8b48418a139818daf2aef6b247aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a90a055a221fefd2e747433f281f4c963121226f83fa87b7718bbb8ddfa4e48c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "561612a6c4796c83ceba89d8b75f94a73defb75d0fd22e738c6b1dba47b3505c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d33e4ebad2ffc30195714cb2c63d5462005ee3400b7b6c605bcaaf0a0993d95"
    sha256 cellar: :any_skip_relocation, ventura:       "1853594af0dcb84cc190c0a4392a8ab58587426c51f802a7a05bde46f8ddcf4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ddffc2432609b7eb58745f0815378f8177ce9d77052bce0d4d63a9bfa840c3"
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
