class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "ec9a87ad777c7daf3e1ecfd731ad5728b51c177d64ec14f1eba2aa5748118fa6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f634db21213e58977337b4a516ba89e56224fe470227bd87f3e712d5bf28007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0076837071303756a8652f81310b7511ce9af58213dee403a500c7eb26494e2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5e9e4268de357a97ad439308949fed8f05cd21e18d7cbfacb1b7cd369873452"
    sha256 cellar: :any_skip_relocation, sonoma:        "64b7423d98d36c207c7745a0105c04d9c0a11f2a0c2b699e51f73542051c66ca"
    sha256 cellar: :any_skip_relocation, ventura:       "5a46fed480e8b697a2289fafe765692da50853a4fbd7e35e99eb37b59579a748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c4ad2d1926bd981ea984ca992348a1affd6b2a07a0eb9c081284ef440e198a6"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", "completion")
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
