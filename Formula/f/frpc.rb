class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "f7678f5c9d3934687976e493a8c5ce9e0d6da39fdea4c7a2fa03a2c289866ac3"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e7db3aff858d6b7db7dae3467ef64a233a4d237628638249cff3375651195b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e7db3aff858d6b7db7dae3467ef64a233a4d237628638249cff3375651195b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e7db3aff858d6b7db7dae3467ef64a233a4d237628638249cff3375651195b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "90981888a6db2c5c2634fb89d889052eca39ef5ee7de43503d001962a9263da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "776601b1dc90e71606f6ca2a9486a486a6fc43683987bebb3d84687a2943ede3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f509935c306129120f26e4967f7a66eb2801945cbe51fd4247c91465731dac3"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frpc" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"

    generate_completions_from_executable(bin/"frpc", "completion")
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
