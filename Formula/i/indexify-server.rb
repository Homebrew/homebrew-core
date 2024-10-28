class IndexifyServer < Formula
  desc "CLI for Indexify, a realtime serving engine for Data-Intensive Generative AI"
  homepage "https://www.tensorlake.ai"
  url "https://github.com/tensorlakeai/indexify.git",
      tag:      "v0.2.6",
      revision: "6ef0c395b5ba253575a2ee924e6cf726d9db239e"
  license "Apache-2.0"

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    binary_url = "https://github.com/tensorlakeai/indexify/releases/download/v#{version}/indexify-server-#{version}-#{os}-#{arch}"

    system "curl", "-L", "-o", "indexify-server", binary_url
    chmod "a+x", "indexify-server"

    bin.install "indexify-server"

    system "curl", "-X", "POST",
           "https://tensorlake.ai/api/analytics",
           "-H", "Content-Type: application/json",
           "-d", "{\"event\": \"indexify_download\", \"platform\": \"#{os}\", \"machine\": \"#{arch}\"}",
           "--max-time", "1", "-s"
  end

  test do
    system bin/"indexify-server", "--version"
  end
end
