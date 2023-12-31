class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.53.2",
      revision: "d505ecb473751e24cdfd2df7676beb5e54eff676"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72dd08c8aa4497658aaee93464e071e452df4cb8feaca8fb2baae758f959e272"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72dd08c8aa4497658aaee93464e071e452df4cb8feaca8fb2baae758f959e272"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72dd08c8aa4497658aaee93464e071e452df4cb8feaca8fb2baae758f959e272"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a595d6bc338b4c9175407b3ecbed91d487a30002993f8f93b6bf9b805526c81"
    sha256 cellar: :any_skip_relocation, ventura:        "3a595d6bc338b4c9175407b3ecbed91d487a30002993f8f93b6bf9b805526c81"
    sha256 cellar: :any_skip_relocation, monterey:       "3a595d6bc338b4c9175407b3ecbed91d487a30002993f8f93b6bf9b805526c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c63fd46a3a30fb51e9cf29670205b8482875847b2c20c2ea0a9d94a988e044d1"
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
