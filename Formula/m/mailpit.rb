class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.30.7.tar.gz"
  sha256 "19366f9b6fb3c8dd8f9c97b2e894133c6fbac2c2fee9657975874a0deab71777"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbff7c755f156725260027a64994d8b5012730d950277d14c46e8df6ef0c60bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f844eb98776e33fa743566cf6075187dd4bcc108e5821888de9971a7528cafc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d359b2ba1755f139faa4e4ac2d4af6344c8c7ab6dd95b458c4e60cc71fb0cc72"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1b334dd6748326be19e41d5ff5f84d7d3f3f1731f7024a8d76bd7c3dd93bf50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "932e02b31aa90ba687a3a420fd28c402b78191d7b47c15de4a7bd89b7f485371"
    sha256 cellar: :any,                 x86_64_linux:  "a2efe0fe3d6145cf5a5701ef86d1ca82ff1301fafd7f477a89711881764b07ca"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-X github.com/axllent/mailpit/config.Version=v#{version}"
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
