class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "1d98f5def313edc19670052ecb123779f03b742ec4a7413b4098e811cb239390"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4256d3386c1c3ff095a65c77d73812d950c9e837da7b637123014a0ed7b659c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6006e52211565404f1b0226645c9fa33b81ea5d8d96ef07e7fdee743d00bc26e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "025bf9679437ff022fe605e880555d9de48e36d6feb389d788d0dbeab0b8cc82"
    sha256 cellar: :any_skip_relocation, sonoma:        "04951a1b4f904651849a23d1da0ede63153beaf8d705fe078ef18efd1a3ecbdd"
    sha256 cellar: :any_skip_relocation, ventura:       "7bdbaa0b55e5f428648c4abe54b4569f54708a3031b2d8f52d39badff30b3404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e30809811aeafc670be90f0b9c648473c8b00913c28fed2b5fadfa96a90400c"
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
