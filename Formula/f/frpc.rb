class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.61.2.tar.gz"
  sha256 "19600d944e05f7ed95bac53c18cbae6ce7eff859c62b434b0c315ca72acb1d3c"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b467a439f868f181510e7f594e2f73780d29219138375fde8097ed700bacbdec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b467a439f868f181510e7f594e2f73780d29219138375fde8097ed700bacbdec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b467a439f868f181510e7f594e2f73780d29219138375fde8097ed700bacbdec"
    sha256 cellar: :any_skip_relocation, sonoma:        "b62720838c9e4903984e4ddeaa2db51b8b86e8f5772ba84ab86ebc6f47e72656"
    sha256 cellar: :any_skip_relocation, ventura:       "b62720838c9e4903984e4ddeaa2db51b8b86e8f5772ba84ab86ebc6f47e72656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56d8a9440e40391f25ee3edb66fbeb709c244ea300fa5a119ebb45de94fbc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56006d1a2333797d28655f839a08ab17396155a67d8f9cb96b39e37fe60a9f53"
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
