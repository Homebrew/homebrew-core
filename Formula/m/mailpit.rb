require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "fb3acabd00c6229adf4da592c9fc2b136c10b5f4a05c36d53bbd73d55617219f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c55307307eb893da77a4c17d3875fc3475b976e044e681d5ddcb6cb96ccb322"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38a653b5e508e9df9601ac21fef7f57c83eef2b5cbb4b8ff2c6a94457ff71933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51a770e4b94d6228e9b35d20be03f66800cab5b8a46f735f1903fd3774e45dc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0ee8eb9658f3f859f9a2e6a1df8870236081bcc654761a31698314b40451e03"
    sha256 cellar: :any_skip_relocation, ventura:        "4185d456d3e7568931310ec9cb396ba984bb9d2d00d6cdf7124c44f9f32828fa"
    sha256 cellar: :any_skip_relocation, monterey:       "83525941bc4253184860f33da43d3a2f6f87118ddbb5f407905208221c4d6e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be249fc150378323ff8d6b1ecd3375d04f90030c12e955ca88081fde5e9d404d"
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
