class PrismCli < Formula
  desc "Set of packages for API mocking and contract testing"
  homepage "https://stoplight.io/open-source/prism"
  url "https://registry.npmjs.org/@stoplight/prism-cli/-/prism-cli-5.12.0.tgz"
  sha256 "43eef5f8b30f0da3d27f4d7dcd539fe91d0f0adfa2c8c5cef7d7e95601113cf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13c54a7c8d5e0ada56a59a40b42c65915f9b5df39f46e03a093a491272b06d07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13c54a7c8d5e0ada56a59a40b42c65915f9b5df39f46e03a093a491272b06d07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13c54a7c8d5e0ada56a59a40b42c65915f9b5df39f46e03a093a491272b06d07"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec079ffe4838d0eef1b31982ed56f4f63884d7ade66e7ab75d3109c6ad17e8f4"
    sha256 cellar: :any_skip_relocation, ventura:       "ec079ffe4838d0eef1b31982ed56f4f63884d7ade66e7ab75d3109c6ad17e8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c54a7c8d5e0ada56a59a40b42c65915f9b5df39f46e03a093a491272b06d07"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    pid = spawn bin/"prism", "mock", "--port", port.to_s, "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/refs/heads/main/tests/v3.0/pass/petstore.yaml"

    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    system "curl", "http://127.0.0.1:#{port}/pets"

    assert_match version.to_s, shell_output("#{bin}/prism --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
