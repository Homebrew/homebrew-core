class Lynkr < Formula
  desc "Self-hosted Claude Code proxy with multi-provider support"
  homepage "https://github.com/vishalveerareddy123/Lynkr"
  url "https://registry.npmjs.org/lynkr/-/lynkr-7.2.5.tgz"
  sha256 "85200ef408488566bc9e4ff6d43e0b290c430018d74b1365e88459889b5f8525"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args, "--omit=optional"
    # Remove tree-sitter prebuilt binaries that trigger non-native architecture audit failures
    %w[tree-sitter tree-sitter-javascript tree-sitter-python tree-sitter-typescript].each do |pkg|
      rm_r(libexec/"lib/node_modules/lynkr/node_modules/#{pkg}", force: true)
    end
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    port = free_port
    server_log = testpath/"server.log"
    env = {
      "PORT"                => port.to_s,
      "NODE_ENV"            => "production",
      "MODEL_PROVIDER"      => "llamacpp",
      "FALLBACK_ENABLED"    => "false",
      "WORKER_POOL_ENABLED" => "false",
    }
    pid = spawn(env, bin/"lynkr", [:out, :err] => server_log.to_s)

    begin
      # Wait for server to start (up to 30 seconds)
      30.times do
        sleep 1
        break if quiet_system("curl", "-sf", "http://127.0.0.1:#{port}/health")
      end
      output = shell_output("curl -s http://127.0.0.1:#{port}/health")
      assert_match "ok", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
