class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "6b574c5068e39794062663e7b897d656b59928d2b3fa282b6705a73501e5e367"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51e1ab31984d2108a7eed0f5d212861f5bfa5d5bdfada87da9faaf9f1204e1bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51e1ab31984d2108a7eed0f5d212861f5bfa5d5bdfada87da9faaf9f1204e1bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51e1ab31984d2108a7eed0f5d212861f5bfa5d5bdfada87da9faaf9f1204e1bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a43744dc21a25fc830eeb4293cb90db76cfa6ac678c0218d00a4433446b9e83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69c94e255d5b4fb2cbd03bd1882e951a8ad6abd17b834e4aa7e5215111bc96d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2684dc14f81b4e7f9ebc75aa60867787530f55281bc0c017550b4d3a6d2bbe3"
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
