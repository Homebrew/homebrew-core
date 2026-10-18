class Autopilot < Formula
  desc "Terminal coding agent for OpenRouter models"
  homepage "https://github.com/sinameraji/autopilot"
  url "https://registry.npmjs.org/autopilot-ai/-/autopilot-ai-1.24.1.tgz"
  sha256 "46595b1bcba5850f99bcd3f511b3285ed6a816b3c29ecf8f5b0d5e4e0613211a"
  license "MIT"

  depends_on "node"

  def install
    ENV["npm_config_build_from_source"] = "true"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node").to_s

    system "npm", "install", *std_npm_args, "--omit=optional", "--no-audit", "--no-fund"

    package = libexec/"lib/node_modules/autopilot-ai"
    Dir.chdir(package) do
      system "npm", "rebuild", "better-sqlite3", "--offline", "--no-audit", "--no-fund"
    end

    bin.install_symlink libexec/"bin/autopilot"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/autopilot --help")

    database = libexec/"lib/node_modules/autopilot-ai/node_modules/better-sqlite3"
    command = <<~SH
      node -e 'const Database = require("#{database}"); const db = new Database(":memory:"); db.exec("create table smoke (value text)"); db.prepare("insert into smoke values (?)").run("sqlite-ok"); console.log(db.prepare("select value from smoke").get().value);'
    SH
    assert_equal "sqlite-ok\n", shell_output(command)
  end
end
