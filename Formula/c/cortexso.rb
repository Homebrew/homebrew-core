require "language/node"

class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://github.com/janhq/cortex.git",
      tag:      "v0.4.16",
      revision: "0ec7db4dc0d6724dae76787f0f2a3e56a0ccdd7d"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"

  depends_on "node" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build

  depends_on :macos

  def install
    cd "cortex-js" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
      system "npm", "run", "build:binary"
      chmod "+x", "cortex"
      bin.install "cortex"
    end
  end

  test do
    port = free_port
    pid = fork { exec "#{bin}/cortex", "serve", "--port", port.to_s }
    sleep 10
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
