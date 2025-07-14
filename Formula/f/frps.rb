class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "e5269cf3d545a90fe3773dd39abe6eb8511f02c1dc0cdf759a65d1e776dc1520"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035d2bbb428e68047e3ea543122c367c402cb9a3dbc5c5b22deebecbd78e8f70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "035d2bbb428e68047e3ea543122c367c402cb9a3dbc5c5b22deebecbd78e8f70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "035d2bbb428e68047e3ea543122c367c402cb9a3dbc5c5b22deebecbd78e8f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "34472a027798177700bce769f92ab6a16a715b8be996ffcbacf1069e7f60ee98"
    sha256 cellar: :any_skip_relocation, ventura:       "34472a027798177700bce769f92ab6a16a715b8be996ffcbacf1069e7f60ee98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f0fed08cae5550779d53c55f9bc53e53f3de5693148be9818a33ad0893dd991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60988fbbf497e623a36dd865cfd9916e45c3a59ef84e8e38ca662a59191b010c"
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
