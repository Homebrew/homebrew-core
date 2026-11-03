class Memex < Formula
  desc "Index and search local agent conversation history"
  homepage "https://github.com/nicosuave/memex"
  url "https://github.com/nicosuave/memex/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "1d9d39227b67d92b441f19a65b950cbdc5b4ed4493e52acb8a6abb397022487d"
  license "MIT"
  head "https://github.com/nicosuave/memex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "51b9977abeaafaad693ca75afdb4cf6487e685b9c4a9edd93059e967c5015eae"
    sha256 cellar: :any, arm64_tahoe:       "5b4657ca63b83712549032e0494d090cf8a8ea8f88bd4ca31dcfb3c9472764ea"
    sha256 cellar: :any, arm64_sequoia:     "e61c8ec553bc9731fd8bbd65b901f40e8a05812ed4fb3a8e10cd00f3ae871870"
    sha256 cellar: :any, arm64_linux:       "3ac2127c6cf098aac4e1a2a4a7eeb9d0a68a25da06e90de9bca5bd1afc4d6636"
    sha256 cellar: :any, x86_64_linux:      "54f9376136fd089bfc1401eb429b4b728fc402c610c8dc8306790bb510203a41"
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
