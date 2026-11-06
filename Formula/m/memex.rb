class Memex < Formula
  desc "Index and search local agent conversation history"
  homepage "https://github.com/nicosuave/memex"
  url "https://github.com/nicosuave/memex/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "a72bd3a5393ce2c4ccbad0447da3ee0d5939e3816c0d3dab2c0918ee30e76dd4"
  license "MIT"
  head "https://github.com/nicosuave/memex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ddb95efd8f9a234156e867e1a18fab2f840e037ec2563fd732d3206f60c5582c"
    sha256 cellar: :any, arm64_tahoe:       "fc00e6e41b3fc956ef519f847b9a1dcb0bd99cd5bdb7a22c3a795019d3fc8318"
    sha256 cellar: :any, arm64_sequoia:     "f61489ff75f350efb9fd5f5e415613ef28952dd40508ffe417e9059815449612"
    sha256 cellar: :any, arm64_linux:       "edf9a1c0a946cc0d2045c316cb1b9e51e05d32f1ddeddb77116665a7d1398758"
    sha256 cellar: :any, x86_64_linux:      "917fac5de8c61adccfb2902e0a43753351ee72fd4eab1b440c198d554afb90f0"
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
