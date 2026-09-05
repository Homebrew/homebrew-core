class Hister < Formula
  desc "Your own search engine"
  homepage "https://hister.org/"
  url "https://github.com/asciimoo/hister/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "fd7373b2bfa6fbec4fe622a8f611c661399b1a5ad38cdc2351ab2feb8fca36b1"
  license "AGPL-3.0-or-later"
  head "https://github.com/asciimoo/hister.git", branch: "master"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "generate", "./..."
    system "go", "build", *std_go_args

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
      Process.wait(pid)
    end
  end
end
