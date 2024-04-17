require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "14005575d65493b47b4fafedcee0c8e92899ec660a0a2d2dd6e6941c0691c628"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "221844fc190b40864e07da3c2d7916d7982fd59b43e63865f5247a0ba22cb583"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80f66542bb050a11247c0ffca764a24c87e38df3988561e6bebbebd552db5499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93d6da65183d034db25380effd414e29075eca224f8bc655a443f10c1eefe406"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4b2c0ecfd1673d72cda10140ad617c6ffa17a87ee8b548b81b9784d0aa6ae53"
    sha256 cellar: :any_skip_relocation, ventura:        "4123df0ac1348cfb3433f6993591bd5b37a6f18656d063ecb40dcf172b5c5718"
    sha256 cellar: :any_skip_relocation, monterey:       "f93da8c9142e5071997d879f8b9d95bbc7bf1b6790f067c8674fde404aed4a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c7e6dbf5b77c7844e7fbdfe2e7aa2c2d471b02d3998d9ac9ff14e0adfdc3343"
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
