class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.62.1.tar.gz"
  sha256 "d0513f1c08f7a6b31f91ddeca64ccdec43726c20d20103de5220055daa04b903"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03d8fc5b6b3824a3bedeb16ec8143e323713f9be8a27dc1c2ff4d0074e52dc13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03d8fc5b6b3824a3bedeb16ec8143e323713f9be8a27dc1c2ff4d0074e52dc13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03d8fc5b6b3824a3bedeb16ec8143e323713f9be8a27dc1c2ff4d0074e52dc13"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbf2624e561538a9b840afbef0e5d7a60c26dd0b7bf4b2f41d96c03136a006b4"
    sha256 cellar: :any_skip_relocation, ventura:       "fbf2624e561538a9b840afbef0e5d7a60c26dd0b7bf4b2f41d96c03136a006b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16bf7f6bbf18503d86f6ec7a3e007cd16422b329a8d25a8d74e537996d9bba6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc7c7b3d48585edd09aabb7d4042c4cee5d6f3bf05c3e405d1b597022503237"
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
