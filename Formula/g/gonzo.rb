class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "6d6a61e76d3def4094996532e29d95b77c91bbf996cd56601809a812240aca59"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f3324f2e8937861a3f468db6d5b2930328fa359c3a6f7f2c79be6aec54d4a25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f3324f2e8937861a3f468db6d5b2930328fa359c3a6f7f2c79be6aec54d4a25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f3324f2e8937861a3f468db6d5b2930328fa359c3a6f7f2c79be6aec54d4a25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f3324f2e8937861a3f468db6d5b2930328fa359c3a6f7f2c79be6aec54d4a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "97fb9ef89647c50a7544a5e5e534348d99676f021d3db2c826176272d76951d6"
    sha256 cellar: :any_skip_relocation, ventura:       "97fb9ef89647c50a7544a5e5e534348d99676f021d3db2c826176272d76951d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47e5bb77575625fe428f27dd9c66f1d96e258db8ab9ad5b9c27e5da2596ebbc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gonzo"

    generate_completions_from_executable(bin/"gonzo", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gonzo --version")

    (testpath/"app.log").write <<~EOS
      2025-09-01T12:00:00Z INFO app started
      2025-09-01T12:01:00Z ERROR failed to connect to db
      2025-09-01T12:02:00Z WARN retrying connection
    EOS
    output = shell_output("#{bin}/gonzo --test-mode -f #{testpath}/app.log")
    assert_match "Test completed successfully", output
  end
end
