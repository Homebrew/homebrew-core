class LlamaSwap < Formula
  desc "Reliable model swapping for any local AI server"
  homepage "https://github.com/mostlygeek/llama-swap"
  url "https://github.com/mostlygeek/llama-swap/archive/refs/tags/v275.tar.gz"
  sha256 "41dbec5689b4d07fa386487c4d6d745216781e111a6ed8deaf13fd1a5edce7de"
  license "MIT"
  head "https://github.com/mostlygeek/llama-swap.git", branch: "main"

  depends_on "go" => :build
  depends_on "node" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "ui" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
  end

  def install
    # Build the web UI into internal/server/ui_dist for the `embed_ui` tag
    cd "ui" do
      system "npm", "--offline", "run", "build"
    end

    # Copy the source (without tests) into internal/mcptools/sourcecode/_src
    # for the `embed_src` tag
    system "make", "src"

    ENV["CGO_ENABLED"] = "0"
    ENV["GOPROXY"] = "off"
    commit = if build.head?
      Utils.git_short_head(length: 7)
    else
      (buildpath/".git-commit").read[0, 7]
    end
    ldflags = %W[
      -X main.version=v#{version}
      -X main.commit=#{commit}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "embed_ui,embed_src")

    (buildpath/"config.yaml").write <<~YAML
      # llama-swap configuration, see the full reference at:
      # https://github.com/mostlygeek/llama-swap/blob/main/docs/config.example.yaml
      models:
        # small model fine tuned for the UI's Help page, needs a recent
        # llama-server on PATH: brew install llama.cpp
        help-agent:
          cmd: llama-server --port ${PORT} -hf llama-swap/LFM3-1.7B-HelpAgent:Q4_K_M --log-verbosity 4
    YAML
    (etc/"llama-swap").install "config.yaml"
  end

  def caveats
    <<~EOS
      The default config at #{etc}/llama-swap/config.yaml uses llama-server,
      which must be a recent version and on your PATH:
        brew install llama.cpp
    EOS
  end

  service do
    run [opt_bin/"llama-swap", "--config", etc/"llama-swap/config.yaml",
         "--listen", "127.0.0.1:7927", "--watch-config"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    working_dir var
    log_path var/"log/llama-swap.log"
    error_log_path var/"log/llama-swap.log"
  end

  test do
    assert_match "version: v#{version}", shell_output("#{bin}/llama-swap --version")

    (testpath/"config.yaml").write <<~YAML
      models:
        test:
          cmd: sleep 60
          proxy: http://127.0.0.1:9999
    YAML
    assert_match "config is valid: 1 model(s)",
                 shell_output("#{bin}/llama-swap --config #{testpath}/config.yaml --validate")

    port = free_port
    pid = spawn bin/"llama-swap", "--config", testpath/"config.yaml", "--listen", "127.0.0.1:#{port}"
    begin
      30.times do
        break if quiet_system "curl", "-fsS", "http://127.0.0.1:#{port}/health"

        sleep 1
      end
      assert_match "\"test\"", shell_output("curl -fsS http://127.0.0.1:#{port}/v1/models")
      assert_match "<html", shell_output("curl -fsSL http://127.0.0.1:#{port}/ui/")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
