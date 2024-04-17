class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.57.0",
      revision: "8f23733f478a9962d3ad4d8e1d8c01dafdb4d49d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b215dfa284e12e87d7dfb015a3f8e154e7efbaaab6deefde340ede161c1fba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b215dfa284e12e87d7dfb015a3f8e154e7efbaaab6deefde340ede161c1fba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b215dfa284e12e87d7dfb015a3f8e154e7efbaaab6deefde340ede161c1fba6"
    sha256 cellar: :any_skip_relocation, sonoma:         "de22e734dba4ae4d3c21ae258ea26735f6c34cd3f0415bbdcee1c10848f93b37"
    sha256 cellar: :any_skip_relocation, ventura:        "de22e734dba4ae4d3c21ae258ea26735f6c34cd3f0415bbdcee1c10848f93b37"
    sha256 cellar: :any_skip_relocation, monterey:       "de22e734dba4ae4d3c21ae258ea26735f6c34cd3f0415bbdcee1c10848f93b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b96c5212b5f09ef96e5f265f5d099c6bbe6a2c337bae8ff656ccc55c678e77"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.toml" => "frp/frpc.toml"
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
