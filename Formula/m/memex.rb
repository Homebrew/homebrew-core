class Memex < Formula
  desc "Index and search local agent conversation history"
  homepage "https://github.com/nicosuave/memex"
  url "https://github.com/nicosuave/memex/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "da80f745becdb2e6ea172a1a7f268b91007afc6d956141cf0f586024ee69d885"
  license "MIT"
  head "https://github.com/nicosuave/memex.git", branch: "main"

  bottle do
    manifest_sha256 "ee01fbabebf65c9817137260b2abdd70cd3fa0cec0e4c26837ee3075807063bc"
    sha256 cellar: :any, arm64_golden_gate: "078cffe3ebdb7d48c5f748a23e76d0b35b8ff1bfc55e67420911486f551bbe0a"
    sha256 cellar: :any, arm64_tahoe:       "b747b0a0120d6b16305dfadddf9635c094ea0f15c2a1aed860b7c633050e7a75"
    sha256 cellar: :any, arm64_sequoia:     "39b6df7fa817c1a21529966e5c64582b794c6e27e54c9336fe0384b2d4e03b63"
    sha256 cellar: :any, arm64_linux:       "b2a097cafad551355f36f8e25b508ecfffe254535d50303b2912eb0b7f0b4920"
    sha256 cellar: :any, x86_64_linux:      "9e6144e5b9260d46513848d7ead73548ab71d492418ca159a09fb39e21cdcb24"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["ORT_LIB_PATH"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args, "--no-default-features"
  end

  service do
    run [opt_bin/"memex", "daemon", "run"]
    keep_alive true
    log_path var/"log/memex.log"
    error_log_path var/"log/memex.log"
  end

  test do
    source = testpath/"claude"
    source.mkpath
    (source/"brew-session.jsonl").write <<~JSONL
      {"type":"user","uuid":"brew-user","sessionId":"brew-session","timestamp":"2026-01-01T00:00:00Z","cwd":"#{testpath}","message":{"role":"user","content":"Find the homebrewneedle conversation."}}
      {"type":"assistant","uuid":"brew-assistant","sessionId":"brew-session","timestamp":"2026-01-01T00:00:01Z","cwd":"#{testpath}","message":{"role":"assistant","content":[{"type":"text","text":"The homebrewneedle conversation was found."}]}}
    JSONL
    root = testpath/"index"
    root.mkpath
    (root/"config.toml").write "auto_index_on_search = false\n"
    system bin/"memex", "index", "--only-source", "claude", "--claude-path", source,
                       "--no-embeddings", "--root", root
    output = shell_output("#{bin}/memex search homebrewneedle " \
                          "--root #{root} --machine local --mode lexical --full")
    results = output.lines.map { |line| JSON.parse(line) }
    assert_equal 2, results.length
    assert_equal ["brew-session"], results.map { |result| result.fetch("session_id") }.uniq
    results.each do |result|
      assert_match "homebrewneedle", result.fetch("text")
    end
  end
end
