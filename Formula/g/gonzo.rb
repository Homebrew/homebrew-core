class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f06376ec4574a44fe5609ba65faf28c54602768aaa77cefb4d7bcfe681b73719"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ecd334e61490b6a734c477bdbe78e7548868bc9bf05d8a78622f25812db057f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ecd334e61490b6a734c477bdbe78e7548868bc9bf05d8a78622f25812db057f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ecd334e61490b6a734c477bdbe78e7548868bc9bf05d8a78622f25812db057f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a065352d7d9669cce6607643f13a0ece207ddf529cc0d024850dd03fb905dd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "300cd6d81176bd15bea9d5ce24611506fb29a1655c4394255012e6bbb55a0886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c1e79002ac9ac510b57a2b50b6d1cda96e6862ad0589dd67058828dfab1ad6"
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

    generate_completions_from_executable(bin/"gonzo", shell_parameter_format: :cobra)
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
