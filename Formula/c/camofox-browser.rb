class CamofoxBrowser < Formula
  desc "Anti-detection browser automation server for AI agents"
  homepage "https://github.com/jo-inc/camofox-browser"
  url "https://registry.npmjs.org/@askjo/camofox-browser/-/camofox-browser-1.18.1.tgz"
  sha256 "b89badde10eaf3df0327c850cdc880560ea445d88bd6502314716a7123df3d66"
  license "MIT"

  depends_on "python@3.15" => :build
  depends_on "node"

  allow_network_access! [:build, :test]

  def install
    system "npm", "install", *std_npm_args

    cd libexec/"lib/node_modules/@askjo/camofox-browser/node_modules/better-sqlite3" do
      system "npm", "run", "build-release"
      rm_r "prebuilds"
    end

    executable = if OS.mac?
      "${HOME}/Library/Caches/camoufox/Camoufox.app/Contents/MacOS/camoufox"
    else
      "${XDG_CACHE_HOME:-${HOME}/.cache}/camoufox/camoufox-bin"
    end
    (bin/"camofox-browser").write_env_script libexec/"bin/camofox-browser",
      CAMOFOX_BIND_HOST:              "${CAMOFOX_BIND_HOST:-127.0.0.1}",
      CAMOUFOX_EXECUTABLE:            "${CAMOUFOX_EXECUTABLE:-#{executable}}",
      CAMOFOX_DISABLE_DEFAULT_ADDONS: "${CAMOFOX_DISABLE_DEFAULT_ADDONS:-1}"
    bin.install_symlink libexec/"bin/camofox-browser-mcp"
  end

  def caveats
    <<~EOS
      Fetch the Camoufox browser version tested with this release before starting:
        npm --prefix #{opt_libexec}/lib/node_modules/@askjo/camofox-browser run fetch-bin

      Homebrew disables automatic browser and addon downloads.
      Set CAMOUFOX_EXECUTABLE to use an existing Camoufox executable.
      Set CAMOFOX_DISABLE_DEFAULT_ADDONS=0 to enable addon downloads.

      The server binds to 127.0.0.1:9377 by default.
      The MCP adapter is installed at:
        #{opt_bin}/camofox-browser-mcp
      For MCP setup and authentication, see:
        https://github.com/jo-inc/camofox-browser/blob/master/mcp/README.md
    EOS
  end

  service do
    run [opt_bin/"camofox-browser"]
    keep_alive true
    log_path var/"log/camofox-browser.log"
    error_log_path var/"log/camofox-browser.log"
  end

  test do
    ENV["CAMOFOX_CRASH_REPORT_ENABLED"] = "false"
    ENV["CAMOFOX_PORT"] = free_port.to_s

    system "node", "-e", <<~JS
      const Database = require("#{libexec}/lib/node_modules/@askjo/camofox-browser/node_modules/better-sqlite3");
      const db = new Database(":memory:");
      if (db.prepare("SELECT 1 AS value").get().value !== 1) process.exit(1);
      db.close();
    JS

    pid = spawn bin/"camofox-browser", [:out, :err] => (testpath/"server.log").to_s
    begin
      output = JSON.parse(shell_output("curl --silent --retry 10 --retry-connrefused --retry-delay 1 " \
                                       "http://127.0.0.1:#{ENV.fetch("CAMOFOX_PORT")}/health"))
      assert_equal true, output.fetch("ok")
      assert_equal "camoufox", output.fetch("engine")

      json = <<~JSON
        {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
        {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
        {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
      JSON
      assert_match "camofox_create_tab", pipe_output(bin/"camofox-browser-mcp", json, 0)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
