class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.55.1",
      revision: "a5b7abfc8b24491a60fb72369b9e980791f63dd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "474afdfe83d046fbee86b398a886cc71a54584c9d693451fb3928f95f58f3478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "474afdfe83d046fbee86b398a886cc71a54584c9d693451fb3928f95f58f3478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "474afdfe83d046fbee86b398a886cc71a54584c9d693451fb3928f95f58f3478"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7045620f13103b2606bf2866640a06ebdaf1b43d6d4457599f0adfd91171bde"
    sha256 cellar: :any_skip_relocation, ventura:        "c7045620f13103b2606bf2866640a06ebdaf1b43d6d4457599f0adfd91171bde"
    sha256 cellar: :any_skip_relocation, monterey:       "c7045620f13103b2606bf2866640a06ebdaf1b43d6d4457599f0adfd91171bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e555909952e6a492f48f0f9023b41c439f6526a4bd34112bd3e9fe1d043917e"
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
