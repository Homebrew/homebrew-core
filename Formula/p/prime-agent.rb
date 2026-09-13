class PrimeAgent < Formula
  desc "Self-improving RLM agent for coding workflows and long-running autonomous tasks"
  homepage "https://github.com/PrimeIntellect-ai/prime-agent"
  url "https://github.com/PrimeIntellect-ai/prime-agent/releases/download/v0.7.0/prime-agent-0.7.0.tgz"
  sha256 "88b6578518c72cd51a825bc80f28e0fef9a64c67de4a7d6fd7afd7ca1b34da0b"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/prime-agent/node_modules"
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"

    koffi = node_modules/"koffi/build/koffi"
    koffi.children.each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}" }

    zeromq = node_modules/"zeromq/build"
    zeromq.children.each { |entry| rm_r(entry) if entry.directory? && entry.basename.to_s != os }
    (zeromq/os).children.each { |dir| rm_r(dir) if dir.basename.to_s != arch }
    (zeromq/os/arch/"node").children.each { |dir| rm_r(dir) if dir.basename.to_s.start_with?("musl") } if OS.linux?

    if OS.mac?
      universal = Dir[node_modules/"@mariozechner/clipboard-darwin-universal/*.node"]
      deuniversalize_machos(*universal) if universal.any?
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prime-agent --version")
  end
end
