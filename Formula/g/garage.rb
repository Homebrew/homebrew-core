class Garage < Formula
  desc "S3 object store so reliable you can run it outside datacenters"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.5.0.tar.gz"
  sha256 "f6ae76cd694b0dd4a625dfd6b167da73a339ababc88b32cd61434fe3af076d51"
  license "AGPL-3.0-or-later"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main-v2"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c5d05da5dff56d882056677b9d2939835d53facad0024059f6f029eabf8e6ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55deb092e3e7ec9d23c38ab7a533ec12bd1ceafa647b063f324d6f9f6384d16a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b984cb34f530401f7c1ec6a81647bb2e4905201d6a20ac509dcb823d047c6f74"
    sha256 cellar: :any,                 arm64_linux:       "5417fef44bf0ed20145a4d4923f4215e3c80d0a59024b1099f1efd77e68d951f"
    sha256 cellar: :any,                 x86_64_linux:      "6fff34c955d6a678a3f368e677671f7f9a936c44477dbd008ece26f8c50fcc47"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src/garage")
  end

  service do
    run [opt_bin/"garage", "--config", etc/"garage/config.toml", "server"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/garage.log"
    error_log_path var/"log/garage.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/garage --version")

    rpc_port = free_port
    api_port = free_port

    (testpath/"garage.toml").write <<~TOML
      data_dir = "#{testpath}/data"
      metadata_dir = "#{testpath}/metadata"

      replication_factor = 1

      rpc_bind_addr = "[::]:#{rpc_port}"
      rpc_public_addr = "127.0.0.1:#{rpc_port}"
      rpc_secret = "bb2763a7c7c397d17eb9d604c063699ab5de605cee438b7f4288e6ff1695081d"
      [s3_api]
      s3_region = "garage"
      api_bind_addr = "[::]:#{api_port}"
      root_domain = ".s3.garage.localhost"
    TOML

    spawn bin/"garage", "--config", testpath/"garage.toml", "server"
    sleep 5
    assert_match "==== HEALTHY NODES ====", shell_output("#{bin}/garage -c #{testpath}/garage.toml status")
  end
end
