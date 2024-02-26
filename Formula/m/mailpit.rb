require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "66236518a6e0747f610f947e576cc0b507b44d7cb0ee36e9540c2d04d137a1b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "852f2be655f315e66788cc4db8b343ee747f33b0f176cce4b7f19556f86612a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a22888b66a811f409804e527708110ecb011fb1d16a7024a9580503226008137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dd9b4a418f091be4fd2b56d90c8ae4372a9b4ae7a8ebf84cb40854fe41f0cff"
    sha256 cellar: :any_skip_relocation, sonoma:         "50dc8fff25da704afe2243504d45cadfa3d4b27c46ea3f8697bf95406b475c3e"
    sha256 cellar: :any_skip_relocation, ventura:        "d2d71609beed31e06e1806f89609b19a44c6c03f82ce9041a8891deae18f69f0"
    sha256 cellar: :any_skip_relocation, monterey:       "8a66af36b5d02c640a625f78424ecfad544f3b222f16c443729a999dba915b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "140beb0e82a77c1facba278855a05d495dcb6ac5c7a9e88c408669a41093face"
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
