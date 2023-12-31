require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "bf290468dd3bc6f1719f1abe618725f022abc134b841b7ecf4b00f30f4ba42c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77d8699b93ea53f01fc5bc05045d9038d215b0c7c2bdfc406796ea159b607182"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "255a69263048925a588447552b39348f294db29302c75473145089d6f334732d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6155461b2f11d457626a4f9586d0cc2497615162477e0303dca9112853417373"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c4aedda1bf2a317b3548480de1eaeddb1bf7e7e176fa2d493cfcc2523feaa58"
    sha256 cellar: :any_skip_relocation, ventura:        "b9b8329be6db13e2b759eb306728fd007b8d1131bf0ace5b0a3cbf66dd118ee9"
    sha256 cellar: :any_skip_relocation, monterey:       "df7a7ccf0244b60f9a019de1808ae2645fc35e71dcf54080867e1d0a310b504f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d2e0ef9bba3d536e20e98dc9330e4614dee322859d6e0991f0952a64cb4d60"
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
