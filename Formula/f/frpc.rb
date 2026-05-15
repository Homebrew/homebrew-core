class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.68.1.tar.gz"
  sha256 "44ed7107bf35e4f68dc0e77cd5805102effa5301528b89ee5ab0ab379088edc6"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f94f8c3a1465dbd7a77edd66358c04d2b52765a8270fa8f5f06666f2db59588"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f94f8c3a1465dbd7a77edd66358c04d2b52765a8270fa8f5f06666f2db59588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f94f8c3a1465dbd7a77edd66358c04d2b52765a8270fa8f5f06666f2db59588"
    sha256 cellar: :any_skip_relocation, sonoma:        "4feda721eff970c8ed30c1d5223030081cde00deea66d7deb79d3ed6a13999c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57c82e126ddd08e0c14e85e2feea0c029f8b4d5ea9fedc88a814a7df910d8557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2deb617e133480817d062db71ace6641e03178f34a229c004e86a6a2f03e25f"
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
