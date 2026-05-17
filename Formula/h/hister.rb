class Hister < Formula
  desc "Your own search engine"
  homepage "https://hister.org/"
  url "https://github.com/asciimoo/hister/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3b1b16854ee88ca461a1a943fb9b831e0bfc2cc8a5b8e08394140f0f7fb9c393"
  license "AGPL-3.0-or-later"
  head "https://github.com/asciimoo/hister.git", branch: "master"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"hister", shell_parameter_format: :cobra)

    (var/"hister").mkpath
  end

  service do
    run [opt_bin/"hister", "listen"]
    keep_alive true
    log_path var/"log/hister.log"
    error_log_path var/"log/hister.log"
    working_dir var/"hister"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hister --version")

    # Generate a default config; exercises the config package and embedded defaults.
    config = testpath/"hister.yml"
    system bin/"hister", "create-config", config
    assert_match "app:", config.read

    # Keep the data directory inside the test sandbox.
    inreplace config, /^(\s*directory:).*$/, "\\1 #{testpath}"

    # Spawn the server and confirm the embedded web UI responds.
    port = free_port
    pid = spawn bin/"hister", "--config", config, "listen", "--address", "127.0.0.1:#{port}"
    begin
      sleep 5
      assert_match(/<html|<!doctype/i, shell_output("curl -fsS http://127.0.0.1:#{port}/"))
    ensure
      Process.kill("TERM", pid)
    end
  end
end
