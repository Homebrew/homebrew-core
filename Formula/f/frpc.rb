class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.56.0",
      revision: "5a6d9f60c27acd10e438d7f724ad929703dccdc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0786d614fd38422ca6216be7e1de52401e8a19a1a40d65f8967e085ae2fffb9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0786d614fd38422ca6216be7e1de52401e8a19a1a40d65f8967e085ae2fffb9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0786d614fd38422ca6216be7e1de52401e8a19a1a40d65f8967e085ae2fffb9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d876e8836b173c009d247a1b80f3e16dfd182c2fb336aad735a0c5560f29e43"
    sha256 cellar: :any_skip_relocation, ventura:        "2d876e8836b173c009d247a1b80f3e16dfd182c2fb336aad735a0c5560f29e43"
    sha256 cellar: :any_skip_relocation, monterey:       "2d876e8836b173c009d247a1b80f3e16dfd182c2fb336aad735a0c5560f29e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75e16c89517557080529a78d0ae25b1b35534fdaf6d686b3b8dbe1031c0e0a7"
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
