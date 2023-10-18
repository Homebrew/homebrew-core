class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.1",
      revision: "31fa3f021ad290df8b2ef4e3f6eecfc49b3cc69f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03637b68d64ccfad6c8075a317248321a30c402bacd116574e18340d8cd33705"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03637b68d64ccfad6c8075a317248321a30c402bacd116574e18340d8cd33705"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03637b68d64ccfad6c8075a317248321a30c402bacd116574e18340d8cd33705"
    sha256 cellar: :any_skip_relocation, sonoma:         "d63d5a6eb8177ad4e39eaa8b1cf6a1934568ce0a9ae3fb67041c02f64004b015"
    sha256 cellar: :any_skip_relocation, ventura:        "d63d5a6eb8177ad4e39eaa8b1cf6a1934568ce0a9ae3fb67041c02f64004b015"
    sha256 cellar: :any_skip_relocation, monterey:       "d63d5a6eb8177ad4e39eaa8b1cf6a1934568ce0a9ae3fb67041c02f64004b015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e5467454b33d8dfffba65c0e7ee6ab5da6f86246f24527b2c5e4d7f7a71d4b"
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
