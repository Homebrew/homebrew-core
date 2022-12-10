class GrammarlyLanguageserver < Formula
  desc "This is a language server implementation of Grammarly"
  homepage "https://github.com/znck/grammarly"
  url "https://github.com/znck/grammarly/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "749e2577f7c04aa9a80a39e7e8cf619e7f7e85341d3a52b9c8174b3295e2e264"
  license "MIT"

  depends_on "pnpm" => :build
  depends_on "rsync" => :build
  depends_on "node@16"

  def install
    (buildpath/".npmrc").append_lines "node-linker = hoisted"
    system "pnpm", "install", "--reporter", "append-only"
    system "pnpm", "rollup", "-c"

    # Disabling shared-workspace-lockfile is necessary to make grammarly-languageserver
    # workspace a standalone package, by copying shared package into the node_modules
    # of the grammarly-languageserver workspace.
    # However, this config will break the rollup compilation, so we reinstall dependency
    # after compilation (redunant works are automatically igored by pnpm)
    (buildpath/".npmrc").append_lines "shared-workspace-lockfile = false"
    system "pnpm", "install", "--reporter", "append-only"
    # remove depDependencies
    system "pnpm", "install", "--prod", "--reporter", "append-only"

    (libexec/"lib/node_modules").mkpath
    # Ruby's built-in copy function does not support recursive copying directories with
    # symlink dereferenced.
    system "rsync", "-aqL", "#{buildpath}/packages/grammarly-languageserver", "#{libexec}/lib/node_modules"
    (libexec/"bin/grammarly-languageserver").write_env_script \
      "#{libexec}/lib/node_modules/grammarly-languageserver/bin/server.js", \
      { NODE_PATH: "#{libexec}/lib/node_modules" }
    chmod("+x", "#{libexec}/bin/grammarly-languageserver")
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    Open3.popen3("#{bin}/grammarly-languageserver --stdio") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
