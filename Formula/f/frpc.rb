class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "e5269cf3d545a90fe3773dd39abe6eb8511f02c1dc0cdf759a65d1e776dc1520"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df72c0a8e47c443bc47cd6a2313c9791fe0686cf049dfd09c6d641aa28e2653f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df72c0a8e47c443bc47cd6a2313c9791fe0686cf049dfd09c6d641aa28e2653f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df72c0a8e47c443bc47cd6a2313c9791fe0686cf049dfd09c6d641aa28e2653f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b520db6738c546e973ded73acb9a3e4edb4383c15861c9430ccbd9ac5901cf1"
    sha256 cellar: :any_skip_relocation, ventura:       "1b520db6738c546e973ded73acb9a3e4edb4383c15861c9430ccbd9ac5901cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9797b982d2fbf14e996b57f7fa4875997aa52e700aec32a36ff408877be437b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c0d4ee291bf23b9a3eaa278c21f15fd2bfc23f416c67176c2e2af93870d311"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end
