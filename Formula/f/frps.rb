class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "4bc2515c4840a48706963a53b919f1d2e75c1dbbd8eed167ba113d4c00c503d9"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c407f6d05232547879383ce10eb4a1cfde9321ea83664ffbf3690ecdc020ac87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c407f6d05232547879383ce10eb4a1cfde9321ea83664ffbf3690ecdc020ac87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c407f6d05232547879383ce10eb4a1cfde9321ea83664ffbf3690ecdc020ac87"
    sha256 cellar: :any_skip_relocation, sonoma:        "886b959110a9b8637e8d40014da32fd70a84fd585cb4641833f9f993f4df83ac"
    sha256 cellar: :any_skip_relocation, ventura:       "886b959110a9b8637e8d40014da32fd70a84fd585cb4641833f9f993f4df83ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c19999db792519656ba88e63f1e04aa9616f22972b4842176f3c85be4d57c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d222ce20ca3e27e11153c132670566b8e0d08f450a448feef47c09cfd61f93ce"
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
