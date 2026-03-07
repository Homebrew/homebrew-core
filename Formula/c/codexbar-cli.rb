class CodexbarCli < Formula
  desc "Command-line interface for CodexBar"
  homepage "https://codexbar.app"
  url "https://github.com/steipete/CodexBar/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "bf86cd45ddbd723337136a2b5808267346044c3ca7e8594c71a3f2ac8420d942"
  license "MIT"

  depends_on "swift" => :build
  depends_on "curl"
  depends_on :linux
  depends_on "sqlite"

  def install
    inreplace "Sources/CodexBarCLI/CLIEntry.swift", "Bundle.main.infoDictionary?[\"CFBundleShortVersionString\"] as? String", "\"#{version}\" as String?"

    system "swift", "build", "-c", "release", "--product", "CodexBarCLI", "--static-swift-stdlib",
           "-Xcc", "-I#{Formula["curl"].opt_include}",
           "-Xcc", "-I#{Formula["sqlite"].opt_include}",
           "-Xlinker", "-L#{Formula["curl"].opt_lib}",
           "-Xlinker", "-L#{Formula["sqlite"].opt_lib}"
    bin.install ".build/release/CodexBarCLI" => "codexbar"
  end

  test do
    assert_match "CodexBar", shell_output("#{bin}/codexbar --help")
    assert_match version.to_s, shell_output("#{bin}/codexbar --version")

    (testpath/".claude/projects/test").mkpath
    (testpath/".claude/projects/test/log.jsonl").write <<~JSON
      {"timestamp":"#{Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")}","type":"assistant","message":{"model":"claude-3-5-sonnet-20240620","usage":{"input_tokens":100,"output_tokens":50}}}
    JSON
    (testpath/".claude/projects/test/log.jsonl").write "\n", mode: "a"

    ENV["HOME"] = testpath
    ENV["CLAUDE_CONFIG_DIR"] = testpath/".claude"

    output = shell_output("#{bin}/codexbar cost --provider claude --format json")
    assert_match "100", output
    assert_match "50", output
  end
end
