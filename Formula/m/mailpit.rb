require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "30ff335d17475be0591bd91c239ecec218826a968612d4fa757dcb704d35901e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f81ef9827d7e963b4d6eb94315bfad0128a4924008773aec0bd32112c473e51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa56654fbd77f1b91d12d5f686707ef71abbc8f9fb9648d222d24ee13233373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "accd513af33c861ef9c77f3af302d3eb8abab933e7a09da1e40ede25349b0ba0"
    sha256 cellar: :any_skip_relocation, ventura:        "a90ad0d2e7a8c5216e3795f94a19bd754146fb52dda4d48ebb2b23d2492459e0"
    sha256 cellar: :any_skip_relocation, monterey:       "81b4984d78fa76badbe902d27475e471e79ae182420a815240e9ce3e90ab6b0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7380a3685cd19db8151559a5c0d0bb9ae0d93ab47e2ab95c4321a404d7ee0b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d59b69f6a692902a83913dbee22939e72e728aa41ef82a85ca74feb8bc4067e"
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
