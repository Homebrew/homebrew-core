require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "fc31947d4bd17e63af93a88b0ab468294fd35de9458cf91293e42bdc3ee9362f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "640d2b016e139a3df2ebe42df3701e2e4068e87548160a7be6fe87030691d9ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01cbc3bd6fe7e74773a8b0f5d812bf6a65a788ac967f571acf265c26de7661b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e08251ba08ba8051b4388cec74c886035688b659f7437a7d3ce7fc5431acafbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "02979a8b2223066d5095122d2d6f4b7bf9da3f2cd656a2f99e7a846f9b8d2a45"
    sha256 cellar: :any_skip_relocation, ventura:        "e966e29dda577a3ee28fc56485a4fbe799624fabdc577f43663f445569aa2013"
    sha256 cellar: :any_skip_relocation, monterey:       "380442f92ba324257bc46b4b36c842c0368e9ba4d489d6328a6dffd3cb497627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c5dcd09023b2bfe259508ba1f6b35ff2a6bcee56d8e0152ae6cb72a72d9d977"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
