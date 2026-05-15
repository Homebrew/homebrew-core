class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "822a723c7e8ac46a10a8a25762b76f98d3da76299dec19154d80db8a072afc31"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4b5d8cb1e2bca1f119473d268723301942e37c0a0036fc55ed7408bfd97d082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b5d8cb1e2bca1f119473d268723301942e37c0a0036fc55ed7408bfd97d082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b5d8cb1e2bca1f119473d268723301942e37c0a0036fc55ed7408bfd97d082"
    sha256 cellar: :any_skip_relocation, sonoma:        "235a0168c402143192516370c3cf189fce56a7821ca6ebbbf9014ce943280d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fdb9b25d5ea73b0ed089f407763ab1d601ed6a6e4f7de74dbd3c45f89adaeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d258c606ab117a21a5b68acf26b3e0cdb1c3a83b4569ae6330769c5072530d"
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
