require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "fae0f3ad9c1f122f18bfe958026e67e35725744b83bb9dba9c3bd3b2ce2c4771"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a66966ae98363f3c9486df3a17ce56974ac41d94bc0de283dd5b60c877930d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "138b76a56da532ebc87fabc8c86059e6e7c468a33c74e8f15aae55a1e062c775"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56df09c4a75e4d985defde0b4194ea46177ff49f582402120daaf7dff4c5b744"
    sha256 cellar: :any_skip_relocation, ventura:        "44826c163bfea4ed0f30181c0e90542998d2bb15318ab925303b7e7a6f3531f6"
    sha256 cellar: :any_skip_relocation, monterey:       "83839ea2cf1ecb57f11c179bb160e929608b631c5021afd5a13171555b379660"
    sha256 cellar: :any_skip_relocation, big_sur:        "532ef379f6f7a716ad6c08c9fb3734a61748ca54a28c875240d8152730fa4e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b83aec0138d0b2abf9a841d74f9ffb81fd174499f23e5fe6acf95a9020c2837e"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-X github.com/axllent/mailpit/config.Version=#{version}"
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

    assert_match version.to_s, shell_output("#{bin}/mailpit version")
  end
end
