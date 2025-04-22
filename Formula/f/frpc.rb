class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "4bc2515c4840a48706963a53b919f1d2e75c1dbbd8eed167ba113d4c00c503d9"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2261f0769e0d331fb06ea5a96780a6a7313d01a8d3bb0c5462bafaca3dc1534a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2261f0769e0d331fb06ea5a96780a6a7313d01a8d3bb0c5462bafaca3dc1534a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2261f0769e0d331fb06ea5a96780a6a7313d01a8d3bb0c5462bafaca3dc1534a"
    sha256 cellar: :any_skip_relocation, sonoma:        "89d49a8285726242f1241491e455bb147f28da8912e62a2b55ab7927d222af63"
    sha256 cellar: :any_skip_relocation, ventura:       "89d49a8285726242f1241491e455bb147f28da8912e62a2b55ab7927d222af63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb3f361924cfa9f758f3e55d36d2ac79914dfa67260a67801f660d6c7b040adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80460dff3624f166fa70338bed624dc53a0887cfef260fd43d7730cd32b7f74c"
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
