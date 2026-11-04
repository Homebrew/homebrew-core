class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "20e2249c2b17cb7624317b0a9a0baed06c80c547d27568d18a32c78e46d79230"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1720ef2beaac60981bf5c2394f34a5392b2a7feb4881a91af74330e7d3d6e013"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1720ef2beaac60981bf5c2394f34a5392b2a7feb4881a91af74330e7d3d6e013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1720ef2beaac60981bf5c2394f34a5392b2a7feb4881a91af74330e7d3d6e013"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7555b423a95740ff7da5060ea1e67eab1a56591a60e0caea7032582f3990eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9b53c6f18a0efe49e2375ff6f2bc5a72f35f17b8b7757a719ca90106e1167e41"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frps" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build-only"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(tags: "frps"), "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"

    generate_completions_from_executable(bin/"frps", "completion")
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
