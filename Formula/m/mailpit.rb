class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.27.11.tar.gz"
  sha256 "7c3e6a50727dc5936293ad43e66e368e26666fb58df222d39d9ca7be52562c42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e77b75a202062d46edf7264dac4953eefae19be7609d9cad5e7ab492623b06d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "813c6e4a0f11e7f7a3cbfef572a2f49a212f5e637838a4b8f088c22a2543bc4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a991d8a72028ff229398c2d46686427137dde2fd42899e6666e53cca2e8c03"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1463111b6f5cf7aa4bcb3737959deb4ded751a273d4f12cd71dba238326a03c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fcb5ff1d7efeccb3203d9a7f5d40bcab6b615c8cbc3a117ec6159eb8e33b923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf91bf753aab60f8ca04554e0c6d56d5ac40c7d6787f0b1e887f834cc598ccff"
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
