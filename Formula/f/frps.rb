class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "18d0a35b965fab7e348aafc7b587847dd04ef2ef84822ed8fd5b9fe46b7ff6d7"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af791cedf1c7a63bf21d7c0b28d3003e77e09b97d74bface15af03447e5c8dc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af791cedf1c7a63bf21d7c0b28d3003e77e09b97d74bface15af03447e5c8dc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af791cedf1c7a63bf21d7c0b28d3003e77e09b97d74bface15af03447e5c8dc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "af08987ef01111b5ac3061372cf57a22fc6a2af33d843d23dd531c68886cea87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf5177b8ec2f34b68ef8022ffa6853a90c604cf170d0426100132b3697602bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec382f14c2eb040918d2ccfd4cbf2baa1ee17b4bb5c77e3e62077a04eb3191c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frps" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frps"), "./cmd/frps"

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
