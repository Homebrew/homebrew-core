class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "eea12aff83447f4d84e4ce64c16ca7e57cf2bafa83afa95aee7d718b26d56488"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea820dd3b78056c02ead9a1b4bb605f52e514668e8a936995c57f14cea0cdcc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c0d44b8bd9d503ae7b781a45e4b0ac1209f1e93e275a2f4fc30f6444ca853a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d8df673009f79cdb409728841be59d8a51c73fb71375b8b4ac5c63f5ef83930"
    sha256 cellar: :any_skip_relocation, sonoma:         "49733a69b603e4fc691cd7fc5480e0e8d242817959aea0cf7b04f60d619e51a9"
    sha256 cellar: :any_skip_relocation, ventura:        "28f63b02c3763be996631cca7e9e9de5912c218ae51785457d3d8cc486314c3f"
    sha256 cellar: :any_skip_relocation, monterey:       "535556a57e1b66344a17a3038d2a6e8ab5aafe9ff50d8d1c0423360cdcf3f76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b15e60650518e369cc0eaaa49c77b2136f2445a61869c74f91f354e9680562e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
