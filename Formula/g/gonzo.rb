class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e8ced8e3ec429c41a0e2dfd3cc11fd1a48af36ddfdbc4fa544100b793444c92f"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b6024269c909eb0594c776bf2b3a4fd0c17aeb42247f7d015650e7fae2ec25e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b6024269c909eb0594c776bf2b3a4fd0c17aeb42247f7d015650e7fae2ec25e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b6024269c909eb0594c776bf2b3a4fd0c17aeb42247f7d015650e7fae2ec25e"
    sha256 cellar: :any_skip_relocation, sonoma:        "affaa2569a3ef599749de76935a6be6d3b94a470c3c5b19b29e162600e292643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9fe4211762319801bb48236fe3b024f128d35a3369e601426f4f8b28ba05e9e"
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
