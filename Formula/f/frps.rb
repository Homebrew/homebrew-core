class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "8feaf56fc3f583a51a59afcab1676f4ccd39c1d16ece08d849f8dc5c1e5bff55"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "15295fa1fbe7edf8f26346f340ff8772c9e94b9f18ab9e1caddec92c3fdabc6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f37bdff3c85450dbcc4a9b515d71087a4161f34609c72e48e2f276890f4e0e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f37bdff3c85450dbcc4a9b515d71087a4161f34609c72e48e2f276890f4e0e0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f37bdff3c85450dbcc4a9b515d71087a4161f34609c72e48e2f276890f4e0e0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b527fcb1cd68b24a69792e61aa0257a3414ea5a96cdad8235ea4fd2d9acb3bf"
    sha256 cellar: :any_skip_relocation, ventura:        "8b527fcb1cd68b24a69792e61aa0257a3414ea5a96cdad8235ea4fd2d9acb3bf"
    sha256 cellar: :any_skip_relocation, monterey:       "8b527fcb1cd68b24a69792e61aa0257a3414ea5a96cdad8235ea4fd2d9acb3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fac75328399af99ecb0797de652ab25291d8090ab069767bfccddb208e642c8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frps", "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"
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
