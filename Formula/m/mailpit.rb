require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.18.5.tar.gz"
  sha256 "244fac6a272cb1f59f6696d0f943c84b6a0ecbdec080099e458efec81fef9eef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1805418443039e6d593efc63a89cef3b1023648b877810f076dac108c6fdf08d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8df0e8828051e6cadc858a293e364525e19846c06270416f48c5d055e2b0edc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c45511d51e0c9fc1830417a96bb93f33c066f56b7ef41ec8dcae1b2f0dd4a9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "200da6b5b7b16c919253c413ee59ba1d46df0df38ab64b55641c7286340c37ce"
    sha256 cellar: :any_skip_relocation, ventura:        "986baa01e5f317c02db0263dd41ce8b011f74122d161cdbeee72077012d771c3"
    sha256 cellar: :any_skip_relocation, monterey:       "0e97fbc8847e5ae4f7f28ddde5aeedfa9e9c63aff4350e9cd308932831286a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a56dd1587ccd16db3c6f87c3dbef8db7e18e199c10324dc9187fe7642bf43d"
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
