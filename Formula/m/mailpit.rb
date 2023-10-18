require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "fda1145f26f362d670a6a558e500100521976e7e870d04a70168c91813415d5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e402f8ff47d26def42e426c6c55398daf76179532e1abfe8bc3c2fcf240c17e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fa40351e0419ba9bad9d0bb83cd61ed49cc78a01cba8047c28d9e6a52ca6cfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f35c385e7ce800e7a82639d64a11cbfbb944765c776ffcd3626f1722ac153c60"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0867cbed33ce0dc319afcb354d1cf1b8522ab7418e22fde5ae3dd5f9c922892"
    sha256 cellar: :any_skip_relocation, ventura:        "9888fb4da5fe1125e47daddb7d72f71d581b8e3fcf1c672f5552af3de60b20c8"
    sha256 cellar: :any_skip_relocation, monterey:       "0b0a95ebdf70efa65952c24cb28807192c9dc2dfcfcebbfda3315c78c789faca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0477dfef85e213ec959619b2ccf7762f3b5d567685944a9ba09473273d99cb36"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=#{version}"
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
