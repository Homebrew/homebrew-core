class Litecontext < Formula
  desc "Local-first context CLI and MCP server"
  homepage "https://github.com/Aries-0331/litecontext"
  url "https://github.com/Aries-0331/litecontext/releases/download/v0.1.2/litecontext_0.1.2_source.tar.gz"
  sha256 "f74b417a08e3e78b318f034027cfeff3ce903a1ca379f99324f05a349d4c742a"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"lc", ldflags: "-s -w -X github.com/Aries-0331/litecontext/internal/engine.Version=#{version}"), "./cmd/litecontext"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc version --json")
    (testpath/"notes").mkpath
    (testpath/"notes/plan.md").write("# Homebrew test\n\nIndexed context\n")
    system bin/"lc", "source", "add", testpath/"notes", "--workspace", testpath/"workspace", "--source-id", "notes"
    assert_match "ready", shell_output("#{bin}/lc doctor --workspace #{testpath}/workspace --json")
  end
end
