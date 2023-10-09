require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "66eb9cff9b5bfe7740fabf6304dfc4577746ce5b782e8868f5043440fc4a122f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "167beb0560995d15b1880e89fac5e6f13600395cb6bb35826434f4df271fcde0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfdecbd77c37c1e20db956055180c8fa0141fc98b0416433ee76b3cb58a9e5ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dfcd7977755ba86b77c00093e616220cbeeb21182c609a9765b8ddc55d0ce4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e145d02284ec4510901dcaded8a24026c42e666b534f521b2ce0c9c7a444efc"
    sha256 cellar: :any_skip_relocation, ventura:        "cd53a141480d401dbe5955b620a195e0376335d29ec208c82d13d7058475e796"
    sha256 cellar: :any_skip_relocation, monterey:       "b9d02e28f75142c242f15472df60327a9250b05675c87f8bf93dfb866760b0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a343a9ea1508463b3989ae69955dab8c4322535faf5f98a7ca2a52064699a6db"
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
