class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.20.5.tar.gz"
  sha256 "2b5420e7f05f7f64beb129687a4cddab007dc766490c3551bffd166993af5c76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f56395405a4d49c5f7b513eb949e598a4da82e10ed81f56ac1666c6b2571f4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f38b68d1d67dfa173cf3686b31f7d465a872695ca78bf8f6eb2bd94be01b3c42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3b2fc25750dd06379839f1e3212c17afba66df4ee3f948c06cc110943082746"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8958a45a3d2cf94e946623c124c6316e20ec1b51457594186b0b21c866bee4b"
    sha256 cellar: :any_skip_relocation, ventura:       "118f1c4450d8b5a0cdc853730338135d567b30ec450f020c12d5e02e16384b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff9c6bc0fcb4a97a9bb7347019143df252e9df2753a158afdbde41a632379aac"
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
