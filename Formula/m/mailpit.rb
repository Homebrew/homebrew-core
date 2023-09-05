require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "ae5ff2536980dfc4b590168eba94f19be9e13b732dc34dcbb7ac6638c836ebb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a2eb9039b5124e5ac5d16deb9df97479348a5d624999ee86d652ffc69e2bbd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f35c4e408b541d5fd55928cee5d70dab4272523024f337283daf30ec494cb6e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82132df6145987195aef12d3cb001ad5ee16e7b80c2820fa2ffbe49b9ec37944"
    sha256 cellar: :any_skip_relocation, ventura:        "fa46178c9f8dd6c73d60101cb01c78d947d5dc7beea45103227a66965ea903b7"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec30cdcdad875f8a64b43bdfa099e92b455c191a4301c64e51c223d3dceedd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f1e060be9b1829e0650b4b0df8a7e0ac60e043cba89dd5004d9ae2c641f267d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43adc992b345c3599d0ea5cc4fd98983947d6a6a287cc8b704de67dc1bd226d2"
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
