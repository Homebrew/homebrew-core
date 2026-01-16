class Garage < Formula
  desc "S3 object store so reliable you can run it outside datacenters"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.1.0.tar.gz"
  sha256 "63b2a0a513464136728bb50a91b40a5911fc25603f3c3e54fe030c01ea5a6084"
  license "AGPL-3.0-or-later"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main-v2"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e40dbc789fce249bcd4f06dc8881402e2cbb1c8d399260f1a4c5cf31cda2436b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d2ad3548011c104c4046c2fa8cc481a2113cb43b8905d831595407de8f6d640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a722cb57f6c41b9cffb42aa5d64651ec355729ab1879197741aa6ad43a3b9804"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecc9478bd28f71a21dea8e761ff9b3d451f00d644aca3837060a747e2062e5fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40cea06dceefd06e4f42938015d28f18b23c0ab02d3356ff04424899284471f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86fb767d900a02b13c7e9f88fe3bd1137e0a067352e97c3cb6ae2d620b3bfc4f"
  end

  depends_on "rust" => :build

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
