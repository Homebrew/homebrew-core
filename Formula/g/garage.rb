class Garage < Formula
  desc "S3 object store so reliable you can run it outside datacenters"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.3.0.tar.gz"
  sha256 "b83a981677676b35400bbbaf20974c396f32da31c7c7630ce55fc3e62c0e2e01"
  license "AGPL-3.0-or-later"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main-v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ce66d3ad9ebe1048f0204180cf99b5412b8df4d0bc0f20e90005d774779b402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3159b0141b055b1db39db05a31e82ed49ef890dca34483c409ca2b7fccf74ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5e6402a6dedd2ea5d1cdca4821be2619a4abf46b6ce758cbaf34c7015d618f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b444c9a1cb4692a260c5e4e71a8071c0474ab0470d09d307a408f48b3ac30bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ff5c34f181cdf64ec1cd1d79e1804419a45b38eb6df6cac5e8aa99c7ebc6e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68e2ff3276a10d859a9ddaa7c900e01f2068324954f41b94e1fa04efbf3a951"
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
