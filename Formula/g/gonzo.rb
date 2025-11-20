class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c8a0c7d3c27049f80b725c723fa08369624615820f2a57889ec36b1156118bf0"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b27c6ede4bfc32378d89db887fb8fd6e47b23bd31513b4dc54e8574c1a694d89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b27c6ede4bfc32378d89db887fb8fd6e47b23bd31513b4dc54e8574c1a694d89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b27c6ede4bfc32378d89db887fb8fd6e47b23bd31513b4dc54e8574c1a694d89"
    sha256 cellar: :any_skip_relocation, sonoma:        "f02d2159775ea21c2dd83381fbb8e8149f34b6d3c2184ee2f235261d1a2d87db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6957bf38027fd01c026d2f6da450cefb5f9290255f5388a3f9c657bd7f988fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e8e2a0b5a9aa4e3af9ddeb85ec001a9ec556849e11b4db808b96d24ca417f6"
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
