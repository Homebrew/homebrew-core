class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "cc9b0c79238f39b18f05ac5076c286166984d55056e8583fd9964b6594f7409f"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d6602046e138f09da26fa730ac9660480847da629d3fbd85bb6179f64b0deb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d6602046e138f09da26fa730ac9660480847da629d3fbd85bb6179f64b0deb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d6602046e138f09da26fa730ac9660480847da629d3fbd85bb6179f64b0deb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4c4aab8a07b939305efa47bc763368bf8a3d43f5df116e0da6fd06cfe2f2e7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b55d2938983e60a000098a29abf11eb79454823ce68bd682e9cc0c301992f30a"
    sha256 cellar: :any,                 x86_64_linux:  "3dcda4692cf03c51c582043450024d31e083a0e352270a6633dc46e9880a1c80"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    # UI build
    system "make", "web-build"

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
