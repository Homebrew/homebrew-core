class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3c57e32ffd159975ddd745476966dd8e1d65450d309efc46f7f5ef3a8c38fc37"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c686cf4405c7e37429cb80d07c90d7c14dfcafe7b2aca85b772b8944b09a664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c686cf4405c7e37429cb80d07c90d7c14dfcafe7b2aca85b772b8944b09a664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c686cf4405c7e37429cb80d07c90d7c14dfcafe7b2aca85b772b8944b09a664"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1629422d0be09cabe893bbd35716aaf60c646b4af6264a02dbe543cc7f1779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abecac10133b436d9cd5b6b7afc881311fe9958bfe9fbc3719089ec325a703b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc7618264ddaffefdee60d2089683e02f8b41c546eecdc9c43efffa94f2ca8a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "prd"), "./cmd/ktea"
  end

  test do
    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"ktea", testpath, [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/ktea #{testpath} > #{output_log}").last
    end
    sleep 1
    assert_match "No clusters configured. Please create your first cluster!", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
